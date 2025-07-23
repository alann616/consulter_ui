import 'dart:io' show Platform;
import 'package:consulter_ui/core/models/enums.dart';
import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:consulter_ui/features/patients/screens/patient_detail_screen.dart';
import 'package:consulter_ui/features/patients/screens/patient_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// --- Widget público principal (sin cambios) ---
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (Platform.isWindows) {
      return const _WindowsShell();
    } else if (Platform.isIOS || Platform.isMacOS) {
      return const _CupertinoShell();
    } else {
      return const _AndroidShell();
    }
  }
}

// =========================================================================
// ===             SHELL PARA WINDOWS (VERSIÓN CORREGIDA)                ===
// =========================================================================
class _WindowsShell extends ConsumerStatefulWidget {
  const _WindowsShell({super.key});

  @override
  ConsumerState<_WindowsShell> createState() => _WindowsShellState();
}

class _WindowsShellState extends ConsumerState<_WindowsShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).asData?.value;
    final userName = user?.name?.split(' ')[0] ?? 'Doctor';
    final selectedPatientId = ref.watch(selectedPatientIdProvider);

    final isPatientDetailVisible =
        _currentIndex == 0 && selectedPatientId != null;
    final isNarrow = fluent.MediaQuery.of(context).size.width < 700;
    final bool showBackButton = isPatientDetailVisible && isNarrow;

    return fluent.NavigationView(
      appBar: fluent.NavigationAppBar(
        title: fluent.Row(
          mainAxisAlignment: fluent.MainAxisAlignment.spaceBetween,
          children: [
            Text('Bienvenido, Dr. $userName',
                style: fluent.FluentTheme.of(context).typography.bodyStrong),
            Text('Cédula Profesional: ${user?.doctorLicense ?? 'N/A'}',
                style: fluent.FluentTheme.of(context).typography.bodyStrong),
          ],
        ),
        leading: showBackButton
            ? fluent.IconButton(
                icon: const Icon(fluent.FluentIcons.back, size: 18),
                onPressed: () =>
                    ref.read(selectedPatientIdProvider.notifier).state = null,
              )
            : null,
        automaticallyImplyLeading: true,
      ),
      pane: fluent.NavigationPane(
        selected: _currentIndex,
        onChanged: (index) {
          setState(() => _currentIndex = index);
        },
        displayMode: fluent.PaneDisplayMode.compact,
        items: [
          fluent.PaneItem(
            icon: const Icon(fluent.FluentIcons.contact_list, size: 18),
            title: const Text('Pacientes'),
            body: const _ResizablePanels(),
          ),
          fluent.PaneItem(
            icon: const Icon(fluent.FluentIcons.history, size: 18),
            title: const Text('Historial'),
            body: const _DocumentHistoryView(),
          ),
        ],
        footerItems: [
          fluent.PaneItemSeparator(),
          fluent.PaneItem(
            icon: const Icon(fluent.FluentIcons.settings, size: 18),
            title: const Text('Ajustes'),
            body: const Center(child: Text('Aquí irá la pantalla de Ajustes')),
          ),
          fluent.PaneItemAction(
            icon: const Icon(fluent.FluentIcons.sign_out, size: 18),
            title: const Text('Cambiar Perfil'),
            onTap: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}

// --- NUEVO WIDGET PARA LA PANTALLA DE HISTORIAL ---
class _DocumentHistoryView extends ConsumerWidget {
  const _DocumentHistoryView();

  String _getDocumentTypeName(DocumentType type) {
    switch (type) {
      case DocumentType.EVOLUTION_NOTE:
        return 'Nota de Evolución';
      case DocumentType.CLINICAL_HISTORY:
        return 'Historia Clínica';
      case DocumentType.PRESCRIPTION:
        return 'Receta Médica';
      default:
        return 'Documento';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPatientId = ref.watch(selectedPatientIdProvider);

    // Si no hay paciente seleccionado, muestra un mensaje.
    if (selectedPatientId == null) {
      return const fluent.Center(
        child: fluent.Column(
          mainAxisAlignment: fluent.MainAxisAlignment.center,
          children: [
            Icon(fluent.FluentIcons.contact_info, size: 48),
            fluent.SizedBox(height: 12),
            Text('Seleccione un paciente para ver su historial de documentos'),
          ],
        ),
      );
    }

    // Si hay un paciente, usa el provider para obtener su historial.
    final historyAsync = ref.watch(documentHistoryProvider(selectedPatientId));
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateFormat timeFormat = DateFormat('hh:mm a');

    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
          title: Text('Historial de Documentos del Paciente')),
      content: fluent.Padding(
        padding: const EdgeInsets.all(16.0),
        child: historyAsync.when(
          loading: () => const fluent.Center(child: fluent.ProgressRing()),
          error: (err, stack) =>
              fluent.Center(child: Text('Error al cargar historial: $err')),
          data: (documents) {
            if (documents.isEmpty) {
              return const fluent.Center(
                  child: Text(
                      'Este paciente no tiene documentos en su historial.'));
            }

            return fluent.Table(
              columnWidths: const {
                0: fluent.FlexColumnWidth(), // Fecha
                1: fluent.IntrinsicColumnWidth(), // Hora
                2: fluent.FlexColumnWidth(2), // Tipo
                3: fluent.FlexColumnWidth(2), // Doctor
                4: fluent.IntrinsicColumnWidth(), // Acciones
              },
              children: [
                // Encabezados de la tabla
                const fluent.TableRow(children: [
                  fluent.Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Fecha',
                          style:
                              TextStyle(fontWeight: fluent.FontWeight.bold))),
                  fluent.Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Hora',
                          style:
                              TextStyle(fontWeight: fluent.FontWeight.bold))),
                  fluent.Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Tipo de Documento',
                          style:
                              TextStyle(fontWeight: fluent.FontWeight.bold))),
                  fluent.Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Doctor a Cargo',
                          style:
                              TextStyle(fontWeight: fluent.FontWeight.bold))),
                  fluent.Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Acciones',
                          style:
                              TextStyle(fontWeight: fluent.FontWeight.bold))),
                ]),
                // Filas de datos
                ...documents.map((doc) => fluent.TableRow(
                      children: [
                        fluent.TableCell(
                            verticalAlignment:
                                fluent.TableCellVerticalAlignment.middle,
                            child: fluent.Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(dateFormat.format(doc.timestamp)))),
                        fluent.TableCell(
                            verticalAlignment:
                                fluent.TableCellVerticalAlignment.middle,
                            child: fluent.Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(timeFormat.format(doc.timestamp)))),
                        fluent.TableCell(
                            verticalAlignment:
                                fluent.TableCellVerticalAlignment.middle,
                            child: fluent.Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    _getDocumentTypeName(doc.documentType)))),
                        fluent.TableCell(
                            verticalAlignment:
                                fluent.TableCellVerticalAlignment.middle,
                            child: fluent.Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(doc.doctorName ?? 'N/A'))),
                        fluent.TableCell(
                          verticalAlignment:
                              fluent.TableCellVerticalAlignment.middle,
                          child: fluent.Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: fluent.FilledButton(
                              child: const Text('Ver'),
                              onPressed: () {
                                // Aquí iría la lógica para navegar al documento específico
                                print(
                                    'Abrir doc ID: ${doc.documentId}, Tipo: ${doc.documentType}');
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --- WIDGET DE PANELES REDIMENSIONABLES CON LÓGICA CORREGIDA ---
class _ResizablePanels extends ConsumerStatefulWidget {
  const _ResizablePanels();

  @override
  ConsumerState<_ResizablePanels> createState() => _ResizablePanelsState();
}

class _ResizablePanelsState extends ConsumerState<_ResizablePanels> {
  double _leftPanelWidth = 350.0;
  final double _minPanelWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final selectedPatientId = ref.watch(selectedPatientIdProvider);

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          ref.read(selectedPatientIdProvider.notifier).state = null;
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 700;
          final double maxPossibleWidth = constraints.maxWidth * 0.7;
          final double maxPanelWidth = maxPossibleWidth > _minPanelWidth
              ? maxPossibleWidth
              : _minPanelWidth;

          if (isNarrow) {
            return selectedPatientId == null
                ? const PatientListScreen()
                : PatientDetailScreen(patientId: selectedPatientId);
          } else {
            _leftPanelWidth =
                _leftPanelWidth.clamp(_minPanelWidth, maxPanelWidth);

            return Row(
              children: [
                SizedBox(
                    width: _leftPanelWidth, child: const PatientListScreen()),
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _leftPanelWidth = (_leftPanelWidth + details.delta.dx)
                          .clamp(_minPanelWidth, maxPanelWidth);
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: Container(
                      width: 4.0,
                      color: fluent.FluentTheme.of(context).accentColor,
                    ),
                  ),
                ),
                const Expanded(child: PatientDetailScreen()),
              ],
            );
          }
        },
      ),
    );
  }
}

// ... El resto de las clases (_CupertinoShell, _AndroidShell) no necesitan cambios ...

class _CupertinoShell extends ConsumerStatefulWidget {
  const _CupertinoShell();
  @override
  ConsumerState<_CupertinoShell> createState() => _CupertinoShellState();
}

class _CupertinoShellState extends ConsumerState<_CupertinoShell> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const PatientListScreen(),
    const Center(child: Text('Aquí irá la pantalla de Citas')),
    const Center(child: Text('Aquí irá la pantalla de Ajustes')),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              label: 'Pacientes', icon: Icon(CupertinoIcons.group)),
          BottomNavigationBarItem(
              label: 'Historial', icon: Icon(CupertinoIcons.calendar)),
          BottomNavigationBarItem(
              label: 'Ajustes', icon: Icon(CupertinoIcons.settings)),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(builder: (context) => _screens[index]);
      },
    );
  }
}

class _AndroidShell extends ConsumerStatefulWidget {
  const _AndroidShell();
  @override
  ConsumerState<_AndroidShell> createState() => _AndroidShellState();
}

class _AndroidShellState extends ConsumerState<_AndroidShell> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const PatientListScreen(),
    const Center(child: Text('Aquí irá la pantalla de Citas')),
    const Center(child: Text('Aquí irá la pantalla de Ajustes')),
  ];
  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: material.BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          material.BottomNavigationBarItem(
              icon: Icon(material.Icons.people_alt_outlined),
              activeIcon: Icon(material.Icons.people_alt),
              label: 'Pacientes'),
          material.BottomNavigationBarItem(
              icon: Icon(material.Icons.calendar_month_outlined),
              activeIcon: Icon(material.Icons.calendar_month),
              label: 'Citas'),
          material.BottomNavigationBarItem(
              icon: Icon(material.Icons.settings_outlined),
              activeIcon: Icon(material.Icons.settings),
              label: 'Ajustes'),
        ],
      ),
    );
  }
}

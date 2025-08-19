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

class _DocumentHistoryView extends ConsumerWidget {
  const _DocumentHistoryView();

  // Función para obtener el nombre del tipo de documento
  String _getDocumentTypeName(DocumentType? type) {
    switch (type) {
      case DocumentType.EVOLUTION_NOTE:
        return 'Nota de Evolución';
      case DocumentType.CLINICAL_HISTORY:
        return 'Historia Clínica';
      case DocumentType.PRESCRIPTION:
        return 'Receta Médica';
      // CAMBIO AQUÍ: Maneja el caso en que el tipo sea null
      case null:
        return 'Tipo Desconocido';
    }
  }

  // Función para obtener solo el primer nombre del paciente
  String _getPatientFirstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'N/A';
    return fullName.split(' ')[0];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos el nuevo provider que no depende de un paciente seleccionado
    final allDocsAsync = ref.watch(allDocumentsProvider);
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'es_MX');
    final DateFormat timeFormat = DateFormat('hh:mm a', 'es_MX');

    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
        title: Text('Historial de Documentos Global'),
      ),
      content: fluent.Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: allDocsAsync.when(
          loading: () => const fluent.Center(child: fluent.ProgressRing()),
          error: (err, stack) =>
              fluent.Center(child: Text('Error al cargar el historial: $err')),
          data: (documents) {
            if (documents.isEmpty) {
              return const fluent.Center(
                  child: Text('No hay documentos registrados en el sistema.'));
            }

            // La tabla con las columnas que solicitaste
            return fluent.SizedBox(
              width: double.infinity,
              child: fluent.Table(
                columnWidths: const {
                  0: fluent.IntrinsicColumnWidth(), // ID
                  1: fluent.FlexColumnWidth(), // Fecha y Hora
                  2: fluent.FlexColumnWidth(2), // Paciente
                  3: fluent.FlexColumnWidth(2), // Tipo de Documento
                  4: fluent.FlexColumnWidth(2), // Doctor
                  5: fluent.IntrinsicColumnWidth(), // Acciones
                },
                children: [
                  // Encabezados de la tabla
                  const fluent.TableRow(children: [
                    _TableHeader('ID'),
                    _TableHeader('Fecha y Hora'),
                    _TableHeader('Paciente'),
                    _TableHeader('Tipo de Documento'),
                    _TableHeader('Doctor a Cargo'),
                    _TableHeader('Acciones'),
                  ]),
                  // Filas de datos
                  ...documents.map((doc) => fluent.TableRow(
                        children: [
                          _TableCell(doc.documentId.toString()),
                          _TableCell(
                              '${dateFormat.format(doc.timestamp)}\n${timeFormat.format(doc.timestamp)}'),
                          _TableCell(_getPatientFirstName(doc.patientName)),
                          _TableCell(_getDocumentTypeName(
                              doc.documentType ?? DocumentType.EVOLUTION_NOTE)),
                          _TableCell(doc.doctorName ?? 'N/A'),
                          fluent.TableCell(
                            verticalAlignment:
                                fluent.TableCellVerticalAlignment.middle,
                            child: fluent.Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: fluent.FilledButton(
                                child: const Text('Ver'),
                                onPressed: () {
                                  // TODO: Implementar la lógica para abrir el documento.
                                  // Necesitarás saber el tipo de documento y el ID para navegar
                                  // a la pantalla de detalle correcta.
                                  print(
                                      'Abrir doc ID: ${doc.documentId}, Tipo: ${doc.documentType}');
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget auxiliar para no repetir el estilo de los encabezados
class _TableHeader extends fluent.StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return fluent.Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: const TextStyle(fontWeight: fluent.FontWeight.bold)),
    );
  }
}

// Widget auxiliar para las celdas de datos
class _TableCell extends fluent.StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return fluent.TableCell(
      verticalAlignment: fluent.TableCellVerticalAlignment.middle,
      child: fluent.Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
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

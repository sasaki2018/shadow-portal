import 'package:flutter/material.dart';

void main() {
  runApp(const ShadowPortalApp());
}

class ShadowPortalApp extends StatelessWidget {
  const ShadowPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Portal - Sistema Patria Cyber',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070B19),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFCC),
          secondary: Color(0xFF0088FF),
          surface: Color(0xFF0F172A),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

// ==================== MODELOS DE DATOS ====================
class Usuario {
  String email;
  String nombre;
  String cedula;
  String telefono;
  String genero;
  String grupoSanguineo;
  String empresa;
  String trabaja;
  String sueldo;
  String direccionTrabajo;
  String gradoEstudios;
  String tcu;
  String datosPagoNomina;
  double saldoPuntos;
  bool esAdmin;

  Usuario({
    required this.email,
    this.nombre = 'Usuario Cyber',
    this.cedula = '',
    this.telefono = '',
    this.genero = '',
    this.grupoSanguineo = '',
    this.empresa = '',
    this.trabaja = 'No',
    this.sueldo = '0',
    this.direccionTrabajo = '',
    this.gradoEstudios = 'Estudiante',
    this.tcu = 'No',
    this.datosPagoNomina = '',
    this.saldoPuntos = 100.0,
    this.esAdmin = false,
  });
}

class Bono {
  String id;
  String titulo;
  double puntos;
  String dirijidoA; // 'Todos', 'Estudiante', 'Trabajador'

  Bono({
    required this.id,
    required this.titulo,
    required this.puntos,
    required this.dirijidoA,
  });
}

// Base de Datos Global Simulada
class SistemaBD {
  static Usuario? usuarioActual;
  static List<Bono> listaBonos = [
    Bono(id: '1', titulo: 'Bono Inicial de Registro', puntos: 100.0, dirijidoA: 'Todos'),
    Bono(id: '2', titulo: 'Bono Universitario Estudiantil', puntos: 150.0, dirijidoA: 'Estudiante'),
  ];
  static List<String> bonosReclamados = [];
}

// ==================== PANTALLA DE AUTENTICACIÓN ====================
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool esLogin = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  String _gradoEstudios = 'Estudiante';

  void _autenticar() {
    if (_emailCtrl.text.isEmpty) return;

    setState(() {
      bool esAdmin = _emailCtrl.text.trim().toLowerCase() == 'admin@teamshadow.com';
      SistemaBD.usuarioActual = Usuario(
        email: _emailCtrl.text.trim(),
        nombre: _nombreCtrl.text.isNotEmpty ? _nombreCtrl.text : 'Usuario Cyber',
        gradoEstudios: _gradoEstudios,
        esAdmin: esAdmin,
      );
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuPrincipal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFCC).withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFF00FFCC), size: 60),
                  const SizedBox(height: 10),
                  Text(
                    esLogin ? 'INICIAR SESIÓN' : 'REGISTRO DE USUARIO',
                    style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 5),
                  const Text('Shadow Portal — Sistema Patria', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 25),
                  if (!esLogin) ...[
                    TextField(
                      controller: _nombreCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person, color: Color(0xFF00FFCC))),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      initialValue: _gradoEstudios,
                      dropdownColor: const Color(0xFF0F172A),
                      items: ['Estudiante', 'Trabajador', 'Desempleado', 'Otro']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _gradoEstudios = v!),
                      decoration: const InputDecoration(labelText: 'Ocupación / Estudios', prefixIcon: Icon(Icons.school, color: Color(0xFF00FFCC))),
                    ),
                    const SizedBox(height: 15),
                  ],
                  TextField(
                    controller: _emailCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email, color: Color(0xFF00FFCC))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock, color: Color(0xFF00FFCC))),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFCC),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _autenticar,
                      child: Text(esLogin ? 'INGRESAR AL PORTAL' : 'CREAR CUENTA PATRIA', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => setState(() => esLogin = !esLogin),
                    child: Text(
                      esLogin ? '¿No tienes cuenta? Regístrate aquí' : '¿Ya tienes cuenta? Inicia Sesión',
                      style: const TextStyle(color: Color(0xFF0088FF)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Tip: Usa "admin@teamshadow.com" para ingresar como Administrador.', style: TextStyle(color: Colors.white38, fontSize: 10), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== MENÚ PRINCIPAL ADAPTATIVO ====================
class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context) {
    final user = SistemaBD.usuarioActual!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B19),
        title: Text('SHADOW PORTAL ${user.esAdmin ? "(ADMIN)" : ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              SistemaBD.usuarioActual = null;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthWrapper()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner Usuario Adaptativo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.4)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 15,
                      runSpacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.nombre, style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Correo: ${user.email} | Rol: ${user.gradoEstudios}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        Chip(
                          avatar: const Icon(Icons.stars, color: Color(0xFF00FFCC), size: 18),
                          label: Text('Puntos: ${user.saldoPuntos.toStringAsFixed(0)} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: const Color(0xFF0088FF).withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Panel de Control Admin
                  if (user.esAdmin) ...[
                    _buildPanelAdmin(),
                    const SizedBox(height: 20),
                  ],

                  const Text('MÓDULOS DE REGISTRO PATRIA', style: TextStyle(color: Color(0xFF0088FF), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 12),

                  // Grid Adaptativo
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: constraints.maxWidth > 600 ? 2.8 : 2.3,
                        children: [
                          _TarjetaModulo(titulo: 'Datos Personales', subtitulo: 'Correo, CI, Teléfono, Sangre', icono: Icons.badge_outlined, onTap: () => _abrir(const DatosPersonalesScreen())),
                          _TarjetaModulo(titulo: 'Datos Laborales', subtitulo: 'Empresa, Sueldo, Dirección', icono: Icons.work_outline, onTap: () => _abrir(const DatosLaboralesScreen())),
                          _TarjetaModulo(titulo: 'Estudios & TCU', subtitulo: 'Nivel Académico', icono: Icons.school_outlined, onTap: () => _abrir(const EstudiosScreen())),
                          _TarjetaModulo(titulo: 'Monedero & Bonos', subtitulo: 'Reclamar Puntos Disponibles', icono: Icons.payments_outlined, onTap: () => _abrir(const SeccionBonosScreen())),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFF0088FF)),
                  const Text('Desarrollado por: Leiver Leandro\nTeam Shadow © 2026', style: TextStyle(fontSize: 12, color: Color(0xFF00FFCC)), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _abrir(Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla)).then((_) => setState(() {}));
  }

  Widget _buildPanelAdmin() {
    final tituloCtrl = TextEditingController();
    final puntosCtrl = TextEditingController();
    String dirijido = 'Todos';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purpleAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.purpleAccent),
              SizedBox(width: 8),
              Text('PANEL ADMIN: CREAR NUEVO BONO', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: tituloCtrl, decoration: const InputDecoration(labelText: 'Nombre del Bono')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(controller: puntosCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Puntos'))),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: dirijido,
                  dropdownColor: const Color(0xFF0F172A),
                  items: ['Todos', 'Estudiante', 'Trabajador'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => dirijido = v!,
                  decoration: const InputDecoration(labelText: 'Dirigido a'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, foregroundColor: Colors.white),
            onPressed: () {
              if (tituloCtrl.text.isNotEmpty && puntosCtrl.text.isNotEmpty) {
                setState(() {
                  SistemaBD.listaBonos.add(Bono(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    titulo: tituloCtrl.text,
                    puntos: double.parse(puntosCtrl.text),
                    dirijidoA: dirijido,
                  ));
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Bono publicado globalmente!')));
              }
            },
            child: const Text('PUBLICAR BONO EN LA PÁGINA'),
          ),
        ],
      ),
    );
  }
}

// Tarjeta Reutilizable Adaptativa
class _TarjetaModulo extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final VoidCallback onTap;

  const _TarjetaModulo({required this.titulo, required this.subtitulo, required this.icono, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0088FF).withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFF00FFCC), size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitulo, style: const TextStyle(color: Colors.white54, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF00FFCC), size: 14),
          ],
        ),
      ),
    );
  }
}

// ==================== SECCIÓN DE BONOS ====================
class SeccionBonosScreen extends StatefulWidget {
  const SeccionBonosScreen({super.key});

  @override
  State<SeccionBonosScreen> createState() => _SeccionBonosScreenState();
}

class _SeccionBonosScreenState extends State<SeccionBonosScreen> {
  @override
  Widget build(BuildContext context) {
    final user = SistemaBD.usuarioActual!;
    final bonosDisponibles = SistemaBD.listaBonos.where((b) => b.dirijidoA == 'Todos' || b.dirijidoA == user.gradoEstudios).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Monedero & Bonos Patria')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF0F172A),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saldo Actual:', style: TextStyle(fontSize: 16)),
                    Text('${user.saldoPuntos.toStringAsFixed(0)} PTS', style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('BONOS DISPONIBLES PARA TU PERFIL:', style: TextStyle(color: Color(0xFF0088FF), fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            ...bonosDisponibles.map((bono) {
              bool yaReclamado = SistemaBD.bonosReclamados.contains(bono.id);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bono.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Recompensa: ${bono.puntos} PTS | Dirigido a: ${bono.dirijidoA}', style: const TextStyle(fontSize: 11, color: Colors.white54)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: yaReclamado ? Colors.grey : const Color(0xFF00FFCC), foregroundColor: Colors.black),
                      onPressed: yaReclamado
                          ? null
                          : () {
                              setState(() {
                                user.saldoPuntos += bono.puntos;
                                SistemaBD.bonosReclamados.add(bono.id);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Bono ${bono.titulo} reclamado!')));
                            },
                      child: Text(yaReclamado ? 'RECLAMADO' : 'RECLAMAR'),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ==================== FORMULARIOS CON SCROLL ADAPTATIVO ====================
Widget _buildInput(String label, IconData icono, {bool isNumber = false, String initialValue = '', Function(String)? onChanged}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icono, color: const Color(0xFF00FFCC)),
        labelText: label,
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

class DatosPersonalesScreen extends StatelessWidget {
  const DatosPersonalesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final u = SistemaBD.usuarioActual!;
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Personales')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput('Correo', Icons.email, initialValue: u.email, onChanged: (v) => u.email = v),
            _buildInput('Cédula (CI)', Icons.badge, isNumber: true, initialValue: u.cedula, onChanged: (v) => u.cedula = v),
            _buildInput('Teléfono', Icons.phone, isNumber: true, initialValue: u.telefono, onChanged: (v) => u.telefono = v),
            _buildInput('Género', Icons.person, initialValue: u.genero, onChanged: (v) => u.genero = v),
            _buildInput('Grupo Sanguíneo', Icons.bloodtype, initialValue: u.grupoSanguineo, onChanged: (v) => u.grupoSanguineo = v),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('GUARDAR DATOS')),
          ],
        ),
      ),
    );
  }
}

class DatosLaboralesScreen extends StatelessWidget {
  const DatosLaboralesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final u = SistemaBD.usuarioActual!;
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Laborales')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput('Empresa', Icons.business, initialValue: u.empresa, onChanged: (v) => u.empresa = v),
            _buildInput('¿Trabaja actualmente? (Sí/No)', Icons.work, initialValue: u.trabaja, onChanged: (v) => u.trabaja = v),
            _buildInput('Sueldo', Icons.attach_money, isNumber: true, initialValue: u.sueldo, onChanged: (v) => u.sueldo = v),
            _buildInput('Dirección Trabajo', Icons.location_on, initialValue: u.direccionTrabajo, onChanged: (v) => u.direccionTrabajo = v),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('GUARDAR DATOS')),
          ],
        ),
      ),
    );
  }
}

class EstudiosScreen extends StatelessWidget {
  const EstudiosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final u = SistemaBD.usuarioActual!;
    return Scaffold(
      appBar: AppBar(title: const Text('Estudios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput('Grado de Estudios / Carrera', Icons.school, initialValue: u.gradoEstudios, onChanged: (v) => u.gradoEstudios = v),
            _buildInput('TCU', Icons.workspace_premium, initialValue: u.tcu, onChanged: (v) => u.tcu = v),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('GUARDAR DATOS')),
          ],
        ),
      ),
    );
  }
}
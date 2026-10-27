import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // INICIALIZACIÓN DE FIREBASE (Asegúrate de colocar tu configuración real si usas flutterfire CLI, 
  // por defecto inicializa con la plataforma web configurada)
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "TU_API_KEY_DE_FIREBASE",
      appId: "TU_APP_ID",
      messagingSenderId: "TU_SENDER_ID",
      projectId: "shadow-portal-db",
      authDomain: "shadow-portal-db.firebaseapp.com",
      storageBucket: "shadow-portal-db.appspot.com",
    ),
  );
  runApp(const ShadowPortalApp());
}

class ShadowPortalApp extends StatelessWidget {
  const ShadowPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Portal - Sistema Patria',
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

// ==================== AUTENTICACIÓN Y CONTROL DE SESIÓN ====================
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
  bool cargando = false;

  void _manejarAuth() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor completa correo y contraseña')));
      return;
    }

    // Validación estricta de Admin
    if (email == 'admin@teamshadow.com' && pass != 'sasaki123') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña de Administrador incorrecta (sasaki123)')));
      return;
    }

    setState(() => cargando = true);

    try {
      UserCredential cred;
      if (esLogin) {
        cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
        // Crear documento inicial en Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
          'email': email,
          'nombre': _nombreCtrl.text.isNotEmpty ? _nombreCtrl.text : 'Usuario Cyber',
          'cedula': '',
          'telefono': '',
          'genero': '',
          'grupoSanguineo': 'O+',
          'empresa': '',
          'trabaja': 'No',
          'sueldo': '0',
          'direccionTrabajo': '',
          'gradoEstudios': 'Estudiante',
          'tcu': 'No',
          'datosPagoNomina': '',
          'saldoPuntos': 100.0,
          'esAdmin': email == 'admin@teamshadow.com',
        });
      }

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuPrincipal()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => cargando = false);
    }
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
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.security, color: Color(0xFF00FFCC), size: 60),
                  const SizedBox(height: 10),
                  Text(esLogin ? 'INICIAR SESIÓN' : 'REGISTRO PATRIA', style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  if (!esLogin) ...[
                    TextField(controller: _nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person))),
                    const SizedBox(height: 15),
                  ],
                  TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email))),
                  const SizedBox(height: 15),
                  TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock))),
                  const SizedBox(height: 25),
                  cargando
                      ? const CircularProgressIndicator(color: Color(0xFF00FFCC))
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FFCC), foregroundColor: Colors.black),
                            onPressed: _manejarAuth,
                            child: Text(esLogin ? 'INGRESAR' : 'REGISTRARSE', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                  TextButton(
                    onPressed: () => setState(() => esLogin = !esLogin),
                    child: Text(esLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión', style: const TextStyle(color: Color(0xFF0088FF))),
                  ),
                  const Text('Admin: admin@teamshadow.com | Pass: sasaki123', style: TextStyle(color: Colors.white38, fontSize: 10), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== MENÚ PRINCIPAL ====================
class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('usuarios').doc(userUid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF00FFCC))));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        bool esAdmin = userData['esAdmin'] ?? false;
        double puntos = (userData['saldoPuntos'] ?? 0.0).toDouble();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF070B19),
            title: Text(esAdmin ? 'SHADOW PORTAL [ADMIN PANEL]' : 'SHADOW PORTAL [PATRIA]'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthWrapper()));
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Banner de Perfil y Saldo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userData['nombre'], style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Sangre: ${userData['grupoSanguineo']} | Ocupación: ${userData['gradoEstudios']}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          Chip(
                            avatar: const Icon(Icons.stars, color: Color(0xFF00FFCC)),
                            label: Text('${puntos.toStringAsFixed(0)} PTS', style: const TextStyle(fontWeight: FontWeight.bold)),
                            backgroundColor: const Color(0xFF0088FF).withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Panel Exclusivo Admin
                    if (esAdmin) ...[
                      const PanelAdminWidget(),
                      const SizedBox(height: 20),
                    ],

                    const Text('MÓDULOS DE REGISTRO', style: TextStyle(color: Color(0xFF0088FF), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.8,
                      children: [
                        _BotonMenu(titulo: 'Datos Personales', subtitulo: 'CI, Teléfono, Sangre, Correo', icono: Icons.badge, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DatosPersonalesScreen()))),
                        _BotonMenu(titulo: 'Datos Laborales', subtitulo: 'Empresa, Sueldo, Dirección', icono: Icons.work, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DatosLaboralesScreen()))),
                        _BotonMenu(titulo: 'Estudios & TCU', subtitulo: 'Grado y Carrera', icono: Icons.school, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EstudiosScreen()))),
                        _BotonMenu(
                          titulo: 'Monedero & Bonos',
                          subtitulo: 'Reclamar Bonos en la Nube',
                          icono: Icons.payments,
                          onTap: () {
                            // VALIDACIÓN OBLIGATORIA DE CAMPOS
                            if (userData['cedula'].toString().isEmpty || userData['telefono'].toString().isEmpty || userData['empresa'].toString().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('¡Obligatorio! Debes llenar tus Datos Personales y Laborales antes de acceder al Monedero.'),
                              ));
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SeccionBonosScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final VoidCallback onTap;
  const _BotonMenu({required this.titulo, required this.subtitulo, required this.icono, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF0088FF).withValues(alpha: 0.5))),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFF00FFCC), size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitulo, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF00FFCC)),
          ],
        ),
      ),
    );
  }
}

// ==================== PANEL ADMIN PARA CREAR BONOS ====================
class PanelAdminWidget extends StatefulWidget {
  const PanelAdminWidget({super.key});

  @override
  State<PanelAdminWidget> createState() => _PanelAdminWidgetState();
}

class _PanelAdminWidgetState extends State<PanelAdminWidget> {
  final tituloCtrl = TextEditingController();
  final puntosCtrl = TextEditingController();
  String filtroTipo = 'Todos'; // 'Todos', 'Estudiante', 'Trabajador'
  String filtroSangre = 'Cualquiera'; // 'Cualquiera', 'O+', 'O-', 'A+', 'B+'

  void _crearBono() async {
    if (tituloCtrl.text.isEmpty || puntosCtrl.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('bonos').add({
      'titulo': tituloCtrl.text.trim(),
      'puntos': double.parse(puntosCtrl.text),
      'dirigidoOcupacion': filtroTipo,
      'dirigidoSangre': filtroSangre,
      'creadoEn': FieldNameServerTime(),
    });

    tituloCtrl.clear();
    puntosCtrl.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Bono creado en Firestore y disponible para los usuarios!')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.purpleAccent)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ADMIN: CREAR BONO ESPECÍFICO EN VIVO', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: tituloCtrl, decoration: const InputDecoration(labelText: 'Nombre del Bono')),
          const SizedBox(height: 8),
          TextField(controller: puntosCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cantidad de Puntos')),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: filtroTipo,
                  dropdownColor: const Color(0xFF0F172A),
                  items: ['Todos', 'Estudiante', 'Trabajador'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => filtroTipo = v!),
                  decoration: const InputDecoration(labelText: 'Ocupación'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: filtroSangre,
                  dropdownColor: const Color(0xFF0F172A),
                  items: ['Cualquiera', 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => filtroSangre = v!),
                  decoration: const InputDecoration(labelText: 'Tipo Sangre'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, foregroundColor: Colors.white),
            onPressed: _crearBono,
            child: const Text('PUBLICAR BONO EN LA NUBE'),
          ),
        ],
      ),
    );
  }

  FieldValue FieldNameServerTime() => FieldValue.serverTimestamp();
}

// ==================== SECCIÓN DE MONEDERO Y RECLAMO DE BONOS ====================
class SeccionBonosScreen extends StatelessWidget {
  const SeccionBonosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Monedero & Bonos en la Nube')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').doc(userUid).snapshots(),
        builder: (context, userSnap) {
          if (!userSnap.hasData) return const Center(child: CircularProgressIndicator());
          var userData = userSnap.data!.data() as Map<String, dynamic>;
          List reclamados = userData['bonosReclamados'] ?? [];
          String miSangre = userData['grupoSanguineo'] ?? 'O+';
          String miOcupacion = userData['gradoEstudios'] ?? 'Estudiante';

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('bonos').snapshots(),
            builder: (context, bonoSnap) {
              if (!bonoSnap.hasData) return const Center(child: CircularProgressIndicator());
              var bonos = bonoSnap.data!.docs;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Tus Puntos: ${userData['saldoPuntos']} PTS', style: const TextStyle(fontSize: 20, color: Color(0xFF00FFCC), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text('BONOS DISPONIBLES SEGÚN TU PERFIL:', style: TextStyle(color: Color(0xFF0088FF), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...bonos.map((doc) {
                    var bono = doc.data() as Map<String, dynamic>;
                    String bonoId = doc.id;
                    String reqOcupacion = bono['dirigidoOcupacion'] ?? 'Todos';
                    String reqSangre = bono['dirigidoSangre'] ?? 'Cualquiera';

                    // Filtros exactos solicitados
                    bool pasaOcupacion = reqOcupacion == 'Todos' || reqOcupacion == miOcupacion;
                    bool pasaSangre = reqSangre == 'Cualquiera' || reqSangre == miSangre;

                    if (!pasaOcupacion || !pasaSangre) return const SizedBox.shrink();

                    bool yaReclamado = reclamados.contains(bonoId);

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
                                Text(bono['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('+${bono['puntos']} PTS | Sangre: $reqSangre | Ocupación: $reqOcupacion', style: const TextStyle(fontSize: 11, color: Colors.white54)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: yaReclamado ? Colors.grey : const Color(0xFF00FFCC), foregroundColor: Colors.black),
                            onPressed: yaReclamado
                                ? null
                                : () async {
                                    double nuevosPuntos = (userData['saldoPuntos'] ?? 0.0) + (bono['puntos'] as num).toDouble();
                                    reclamados.add(bonoId);

                                    await FirebaseFirestore.instance.collection('usuarios').doc(userUid).update({
                                      'saldoPuntos': nuevosPuntos,
                                      'bonosReclamados': reclamados,
                                    });

                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Bono reclamado con éxito en la base de datos!')));
                                  },
                            child: Text(yaReclamado ? 'RECLAMADO' : 'RECLAMAR'),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ==================== PANTALLAS DE REGISTRO GUARDADAS EN LA NUBE ====================
class DatosPersonalesScreen extends StatelessWidget {
  const DatosPersonalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Personales')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(userUid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;

          final cedulaCtrl = TextEditingController(text: data['cedula']);
          final telefonoCtrl = TextEditingController(text: data['telefono']);
          final generoCtrl = TextEditingController(text: data['genero']);
          String sangre = data['grupoSanguineo'] ?? 'O+';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(controller: cedulaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cédula de Identidad (CI)')),
                const SizedBox(height: 12),
                TextField(controller: telefonoCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Número de Teléfono')),
                const SizedBox(height: 12),
                TextField(controller: generoCtrl, decoration: const InputDecoration(labelText: 'Género')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: sangre,
                  dropdownColor: const Color(0xFF0F172A),
                  items: ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => sangre = v!,
                  decoration: const InputDecoration(labelText: 'Grupo Sanguíneo'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('usuarios').doc(userUid).update({
                      'cedula': cedulaCtrl.text,
                      'telefono': telefonoCtrl.text,
                      'genero': generoCtrl.text,
                      'grupoSanguineo': sangre,
                    });
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos personales guardados en la nube')));
                  },
                  child: const Text('GUARDAR CAMBIOS'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DatosLaboralesScreen extends StatelessWidget {
  const DatosLaboralesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Laborales')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(userUid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;

          final empresaCtrl = TextEditingController(text: data['empresa']);
          final sueldoCtrl = TextEditingController(text: data['sueldo']);
          final dirCtrl = TextEditingController(text: data['direccionTrabajo']);
          String trabaja = data['trabaja'] ?? 'No';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(controller: empresaCtrl, decoration: const InputDecoration(labelText: 'Empresa en la que trabajas')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: trabaja,
                  dropdownColor: const Color(0xFF0F172A),
                  items: ['Sí', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => trabaja = v!,
                  decoration: const InputDecoration(labelText: '¿Trabaja actualmente?'),
                ),
                const SizedBox(height: 12),
                TextField(controller: sueldoCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sueldo')),
                const SizedBox(height: 12),
                TextField(controller: dirCtrl, decoration: const InputDecoration(labelText: 'Dirección donde trabaja')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('usuarios').doc(userUid).update({
                      'empresa': empresaCtrl.text,
                      'trabaja': trabaja,
                      'sueldo': sueldoCtrl.text,
                      'direccionTrabajo': dirCtrl.text,
                    });
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos laborales guardados en la nube')));
                  },
                  child: const Text('GUARDAR CAMBIOS'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EstudiosScreen extends StatelessWidget {
  const EstudiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Estudios & TCU')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(userUid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;

          String grado = data['gradoEstudios'] ?? 'Estudiante';
          final tcuCtrl = TextEditingController(text: data['tcu']);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: grado,
                  dropdownColor: const Color(0xFF0F172A),
                  items: ['Estudiante', 'Trabajador', 'Desempleado', 'Otro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => grado = v!,
                  decoration: const InputDecoration(labelText: 'Grado de estudios / Ocupación'),
                ),
                const SizedBox(height: 12),
                TextField(controller: tcuCtrl, decoration: const InputDecoration(labelText: 'TCU (Técnico Superior Universitario)')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('usuarios').doc(userUid).update({
                      'gradoEstudios': grado,
                      'tcu': tcuCtrl.text,
                    });
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estudios actualizados en la nube')));
                  },
                  child: const Text('GUARDAR CAMBIOS'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
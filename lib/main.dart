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
        scaffoldBackgroundColor: const Color(0xFF070B19), // Azul muy oscuro profundo
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFCC), // Verde Neón / Cian
          secondary: Color(0xFF0088FF), // Azul Neón
          surface: Color(0xFF0F172A),
        ),
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  // Simulación de Estado de Portal (Estilo Patria)
  double saldoBono = 150.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo Espacial con Gradiente Futurista
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 1.2,
                colors: [
                  Color(0xFF131C38),
                  Color(0xFF070B19),
                  Color(0xFF02040A),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Cyber
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FFCC).withValues(alpha: 0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SHADOW PORTAL v2.0',
                              style: TextStyle(
                                color: Color(0xFF00FFCC),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'Sistema de Gestión Patria',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                        Chip(
                          avatar: const Icon(Icons.account_balance_wallet, color: Color(0xFF00FFCC), size: 18),
                          label: Text(
                            'Bono: \$$saldoBono',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: const Color(0xFF0088FF).withValues(alpha: 0.3),
                          side: const BorderSide(color: Color(0xFF00FFCC)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    ' MÓDULOS DE REGISTRO',
                    style: TextStyle(
                      color: Color(0xFF0088FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Opciones de Menú
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 2.8,
                      children: [
                        _TarjetaCyber(
                          titulo: 'Datos Personales',
                          subtitulo: 'Correo, CI, Teléfono, Grupo Sanguíneo',
                          icono: Icons.badge_outlined,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DatosPersonalesScreen())),
                        ),
                        _TarjetaCyber(
                          titulo: 'Datos Laborales',
                          subtitulo: 'Empresa, Sueldo, Dirección',
                          icono: Icons.work_outline,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DatosLaboralesScreen())),
                        ),
                        _TarjetaCyber(
                          titulo: 'Estudios & TCU',
                          subtitulo: 'Grado académico y Especialidad',
                          icono: Icons.school_outlined,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EstudiosScreen())),
                        ),
                        _TarjetaCyber(
                          titulo: 'Datos Bancarios & Bonos',
                          subtitulo: 'Nómina y Cobro de Bonos',
                          icono: Icons.payments_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DatosBancariosScreen(
                                saldoActual: saldoBono,
                                onReclamarBono: () {
                                  setState(() {
                                    saldoBono += 50.0;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF0088FF)),
                  const SizedBox(height: 5),
                  // Créditos
                  const Text(
                    'Desarrollado por: Leiver Leandro\nTeam Shadow © 2026',
                    style: TextStyle(fontSize: 12, color: Color(0xFF00FFCC), fontWeight: FontWeight.w500, letterSpacing: 1),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta Cyber Reutilizable
class _TarjetaCyber extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final VoidCallback onTap;

  const _TarjetaCyber({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0088FF).withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0088FF).withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFF00FFCC), size: 36),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF00FFCC), size: 16),
          ],
        ),
      ),
    );
  }
}

// Estilo Base de Formulario Cyber
Widget _buildEstiloInput(String label, IconData icono, {bool isNumber = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: TextField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icono, color: const Color(0xFF00FFCC)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color(0xFF0088FF).withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00FFCC)),
        ),
      ),
    ),
  );
}

// 1. DATOS PERSONALES
class DatosPersonalesScreen extends StatelessWidget {
  const DatosPersonalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Personales'), backgroundColor: const Color(0xFF070B19)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildEstiloInput('Correo Electrónico', Icons.email_outlined),
            _buildEstiloInput('Género', Icons.people_outline),
            _buildEstiloInput('Número de Teléfono', Icons.phone_outlined, isNumber: true),
            _buildEstiloInput('Cédula de Identidad (CI)', Icons.badge_outlined, isNumber: true),
            _buildEstiloInput('Grupo Sanguíneo (ej. O+, A-)', Icons.bloodtype_outlined),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFCC),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos Personales Guardados en el Sistema Patria')),
                );
              },
              child: const Text('GUARDAR DATOS', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. DATOS LABORALES
class DatosLaboralesScreen extends StatelessWidget {
  const DatosLaboralesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Laborales'), backgroundColor: const Color(0xFF070B19)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildEstiloInput('Empresa en la que trabajas', Icons.business_outlined),
            _buildEstiloInput('¿Trabaja actualmente? (Sí/No)', Icons.work_history_outlined),
            _buildEstiloInput('Sueldo Mensual', Icons.attach_money_outlined, isNumber: true),
            _buildEstiloInput('Dirección donde trabaja', Icons.location_on_outlined),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFCC),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos Laborales Registrados')),
                );
              },
              child: const Text('REGISTRAR EMPLEO', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. ESTUDIOS
class EstudiosScreen extends StatelessWidget {
  const EstudiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudios académicos'), backgroundColor: const Color(0xFF070B19)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildEstiloInput('Grado de estudios y Carrera actual', Icons.school_outlined),
            _buildEstiloInput('TCU (Técnico Superior Universitario)', Icons.workspace_premium_outlined),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFCC),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nivel Académico Actualizado')),
                );
              },
              child: const Text('ACTUALIZAR ESTUDIOS', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. DATOS BANCARIOS & BONOS (Funcionalidad Interactiva)
class DatosBancariosScreen extends StatelessWidget {
  final double saldoActual;
  final VoidCallback onReclamarBono;

  const DatosBancariosScreen({
    super.key,
    required this.saldoActual,
    required this.onReclamarBono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Bancarios y Bonos'), backgroundColor: const Color(0xFF070B19)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildEstiloInput('Cuenta de Pago de Nómina (Banco / N° Cuenta)', Icons.account_balance_outlined),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF00FFCC)),
              ),
              child: Column(
                children: [
                  const Text(
                    'SISTEMA DE BONOS PATRIA',
                    style: TextStyle(color: Color(0xFF00FFCC), fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Saldo en Monedero: \$$saldoActual',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088FF),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('RECLAMAR BONO INDEPENDENCIA (USD 50.00)'),
                    onPressed: () {
                      onReclamarBono();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Bono de 50.00 acreditado exitosamente!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
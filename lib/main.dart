import 'package:flutter/material.dart';

void main() {
  runApp(const ShadowPortalApp());
}

class ShadowPortalApp extends StatelessWidget {
  const ShadowPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Portal - Team Shadow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shadow Portal — Menú Principal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Seleccione una sección del formulario:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 2.5,
                children: [
                  _BotonMenu(
                    titulo: 'Datos Personales',
                    icono: Icons.person,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DatosPersonalesScreen()),
                    ),
                  ),
                  _BotonMenu(
                    titulo: 'Datos Laborales',
                    icono: Icons.work,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DatosLaboralesScreen()),
                    ),
                  ),
                  _BotonMenu(
                    titulo: 'Estudios',
                    icono: Icons.school,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EstudiosScreen()),
                    ),
                  ),
                  _BotonMenu(
                    titulo: 'Datos Bancarios',
                    icono: Icons.account_balance,
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DatosBancariosScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Créditos solicitados
            const Text(
              'Desarrollado por: Leiver Leandro\nTeam Shadow © 2026',
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  const _BotonMenu({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      onPressed: onTap,
      icon: Icon(icono, size: 28),
      label: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

// ==================== 1. DATOS PERSONALES ====================
class DatosPersonalesScreen extends StatelessWidget {
  const DatosPersonalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Personales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Género', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Número de Teléfono', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Cédula de Identidad (CI)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Grupo Sanguíneo (ej. O+, A-)', border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}

// ==================== 2. DATOS LABORALES ====================
class DatosLaboralesScreen extends StatelessWidget {
  const DatosLaboralesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Laborales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Empresa en la que trabajas', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: '¿Trabaja actualmente? (Sí/No)', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Sueldo', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Dirección donde trabaja', border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. ESTUDIOS ====================
class EstudiosScreen extends StatelessWidget {
  const EstudiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            TextField(decoration: InputDecoration(labelText: '¿En qué grado de estudios estás y qué estudias?', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'TCU (Técnico Superior Universitario)', border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}

// ==================== 4. DATOS BANCARIOS ====================
class DatosBancariosScreen extends StatelessWidget {
  const DatosBancariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Bancarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Datos de pago de nómina (Banco / Cuenta)', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Pago de bonos', border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}
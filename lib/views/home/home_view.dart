import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showConsulta = false;
  final _dniController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _resultadoConsulta;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dniController.dispose();
    super.dispose();
  }

  Future<void> _consultarTramite() async {
    if (_dniController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor ingrese un DNI'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    if (_dniController.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El DNI debe tener 8 dígitos'),
          backgroundColor: Colors.orange.shade400,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _resultadoConsulta = null;
    });

    final resultado = await ApiService.consultarTramite(_dniController.text);

    setState(() {
      _isLoading = false;
      _resultadoConsulta = resultado;
    });

    if (resultado == null ||
        resultado['data'] == null ||
        resultado['data'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se encontraron resultados para este DNI'),
          backgroundColor: Colors.orange.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenido principal
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                children: [
                  // Logo animado
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF0a9e9d), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF0a9e9d).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.school,
                        size: 50,
                        color: Color(0xFF0a9e9d),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Título UDH
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'UDH',
                          style: TextStyle(
                            color: Color(0xFF2f2e2e),
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Universidad de Huánuco',
                          style: TextStyle(
                            color: Color.fromARGB(255, 114, 93, 44),
                            fontSize: 16,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 100,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0a9e9d),
                                Color(0xFFebcb79),
                                Color(0xFF0a9e9d),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50),

                  // Tarjeta principal
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF0a9e9d).withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0a9e9d).withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Grados y Títulos',
                              style: TextStyle(
                                color: Color(0xFF2f2e2e),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),

                            // Botón CONSULTAS
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _showConsulta = !_showConsulta;
                                    if (!_showConsulta) {
                                      _resultadoConsulta = null;
                                      _dniController.clear();
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0a9e9d),
                                        Color(0xFF04787c),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFF0a9e9d,
                                        ).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 40,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.search,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'CONSULTAS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          _showConsulta
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Sección desplegable
                            AnimatedSize(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: _showConsulta
                                  ? Container(
                                      margin: EdgeInsets.only(top: 24),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(
                                            0xFF0a9e9d,
                                          ).withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Consultar Trámite por DNI',
                                            style: TextStyle(
                                              color: Color(0xFF2f2e2e),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          TextField(
                                            controller: _dniController,
                                            keyboardType: TextInputType.number,
                                            maxLength: 8,
                                            style: TextStyle(
                                              color: Color(0xFF2f2e2e),
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Número de DNI',
                                              labelStyle: TextStyle(
                                                color: Color(0xFF7e7767),
                                              ),
                                              hintText: 'Ej: 12345678',
                                              prefixIcon: Icon(
                                                Icons.badge,
                                                color: Color(0xFF0a9e9d),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              counterText: '',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Color(
                                                    0xFF0a9e9d,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Color(
                                                    0xFF0a9e9d,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0a9e9d),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: _isLoading
                                                ? null
                                                : _consultarTramite,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                0xFF0a9e9d,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: _isLoading
                                                ? SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.white),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.search,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'BUSCAR',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          if (_resultadoConsulta != null &&
                                              _resultadoConsulta!['data'] !=
                                                  null &&
                                              _resultadoConsulta!['data']
                                                  .isNotEmpty) ...[
                                            SizedBox(height: 20),
                                            Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Color(
                                                    0xFF0a9e9d,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Color(
                                                          0xFF0a9e9d,
                                                        ),
                                                        size: 24,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Estudiante Encontrado',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF0a9e9d,
                                                          ),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Divider(
                                                    color: Color(
                                                      0xFF0a9e9d,
                                                    ).withOpacity(0.2),
                                                  ),
                                                  SizedBox(height: 12),
                                                  _buildResultRow(
                                                    'Código:',
                                                    _resultadoConsulta!['data'][0]['codigo'] ??
                                                        'N/A',
                                                  ),
                                                  _buildResultRow(
                                                    'Nombres:',
                                                    _resultadoConsulta!['data'][0]['nombre'] ??
                                                        'N/A',
                                                  ),
                                                  _buildResultRow(
                                                    'Primer Apellido:',
                                                    _resultadoConsulta!['data'][0]['pri_ape'] ??
                                                        'N/A',
                                                  ),
                                                  _buildResultRow(
                                                    'Segundo Apellido:',
                                                    _resultadoConsulta!['data'][0]['seg_ape'] ??
                                                        'N/A',
                                                  ),
                                                  _buildResultRow(
                                                    'DNI:',
                                                    _resultadoConsulta!['data'][0]['docu_num'] ??
                                                        'N/A',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Footer
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      '© 2025 UDH - Todos los derechos reservados',
                      style: TextStyle(
                        color: Color(0xFF7e7767).withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Logo de sesión en la esquina superior derecha
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF0a9e9d).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF0a9e9d).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF0a9e9d), size: 24),
                      SizedBox(width: 6),
                      Icon(Icons.logout, color: Color(0xFF0a9e9d), size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF7e7767),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Color(0xFF2f2e2e), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

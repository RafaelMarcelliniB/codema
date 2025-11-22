import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // agregado: para inputFormatters (solo números)
import '../../services/api_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
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
    final dni = _dniController.text.trim();

    if (dni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor ingrese un DNI'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    if (!RegExp(r'^\d{8}$').hasMatch(dni)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El DNI debe tener 8 dígitos numéricos'),
          backgroundColor: Colors.orange.shade400,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _resultadoConsulta = null;
    });

    try {
      final resultado = await ApiService.consultarTramite(dni);

      if (resultado is! Map<String, dynamic> && resultado != null) {
        setState(() {
          _resultadoConsulta = {'data': resultado};
        });
      } else {
        setState(() {
          _resultadoConsulta = resultado as Map<String, dynamic>?;
        });
      }
    } catch (e) {

      setState(() {
        _resultadoConsulta = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al consultar. Revisa tu conexión.'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {

    final List<dynamic> dataList = (_resultadoConsulta != null &&
            _resultadoConsulta!['data'] != null &&
            _resultadoConsulta!['data'] is List &&
            (_resultadoConsulta!['data'] as List).isNotEmpty)
        ? List<dynamic>.from(_resultadoConsulta!['data'] as List)
        : [];

    final bool hasObservaciones = dataList.isNotEmpty && dataList.any((dataRow) {
      return (
        (dataRow['observacion_matricula'] != null && dataRow['observacion_matricula'].toString().isNotEmpty) ||
        (dataRow['observacion_tesoreria'] != null && dataRow['observacion_tesoreria'].toString().isNotEmpty) ||
        (dataRow['observacion_idiomas'] != null && dataRow['observacion_idiomas'].toString().isNotEmpty) ||
        (dataRow['observacion_repositorio'] != null && dataRow['observacion_repositorio'].toString().isNotEmpty) ||
        (dataRow['observacion_prog_acad'] != null && dataRow['observacion_prog_acad'].toString().isNotEmpty) ||
        (dataRow['observacion_facultad'] != null && dataRow['observacion_facultad'].toString().isNotEmpty) ||
        (dataRow['observacion_fotografia'] != null && dataRow['observacion_fotografia'].toString().isNotEmpty)
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [

            SingleChildScrollView(

              padding: EdgeInsets.fromLTRB(24, 30, 24, 140),
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
                                          _showConsulta ? Icons.expand_less : Icons.expand_more,
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
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
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


                                          // Campo DNI
                                          TextField(
                                            controller: _dniController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly, 
                                            ],
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
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0a9e9d).withOpacity(0.3),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0a9e9d).withOpacity(0.3),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0a9e9d),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: _isLoading ? null : _consultarTramite,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF0a9e9d),
                                              padding: EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: _isLoading
                                                ? SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          if (dataList.isNotEmpty) ...[
                                    
                                            ...dataList.map<Widget>((dataRow) => Column(
                                              children: [
                                                SizedBox(height: 20),
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF0a9e9d),
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Text(
                                                          dataRow['den_grad']?.toString() ?? '',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        '${dataRow['nombre'] ?? ''} ${dataRow['pri_ape'] ?? ''} ${dataRow['seg_ape'] ?? ''}',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Color(0xFF2f2e2e),
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),

                                                      _buildStatusRow(
                                                        'Oficina de Matrícula',
                                                        dataRow['es_matricula'],
                                                        observacion: dataRow['observacion_matricula'],
                                                      ),
                                                      if (dataRow['observacion_matricula'] != null && dataRow['observacion_matricula'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_matricula'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Oficina de Tesorería',
                                                        dataRow['es_tesoreria'],
                                                        observacion: dataRow['observacion_tesoreria'],
                                                      ),
                                                      if (dataRow['observacion_tesoreria'] != null && dataRow['observacion_tesoreria'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_tesoreria'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Centro de Idiomas',
                                                        dataRow['es_idiomas'],
                                                        observacion: dataRow['observacion_idiomas'],
                                                      ),
                                                      if (dataRow['observacion_idiomas'] != null && dataRow['observacion_idiomas'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_idiomas'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Repositorio Institucional',
                                                        dataRow['es_repositorio'],
                                                        observacion: dataRow['observacion_repositorio'],
                                                      ),
                                                      if (dataRow['observacion_repositorio'] != null && dataRow['observacion_repositorio'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_repositorio'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Programa Académico',
                                                        dataRow['es_prog_acad'],
                                                        observacion: dataRow['observacion_prog_acad'],
                                                      ),
                                                      if (dataRow['observacion_prog_acad'] != null && dataRow['observacion_prog_acad'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_prog_acad'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Facultad',
                                                        dataRow['es_facultad'],
                                                        observacion: dataRow['observacion_facultad'],
                                                      ),
                                                      if (dataRow['observacion_facultad'] != null && dataRow['observacion_facultad'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_facultad'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Fotografía',
                                                        dataRow['es_fotografia'],
                                                        observacion: dataRow['observacion_fotografia'],
                                                      ),
                                                      if (dataRow['observacion_fotografia'] != null && dataRow['observacion_fotografia'].toString().isNotEmpty) ...[
                                                        SizedBox(height: 8),
                                                        _buildObservationBox(dataRow['observacion_fotografia'].toString()),
                                                      ],

                                                      _buildStatusRow(
                                                        'Estado',
                                                        dataRow['es_completado'],
                                                        observacion: null,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )).toList(),
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

            // Footer 
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Text(
                    '© 2025 UDH - Todos los derechos reservados',
                    style: TextStyle(
                      color: Color(0xFF7e7767).withOpacity(0.6),
                      fontSize: 12,
                    ),
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

  Widget _buildStatusRow(String label, dynamic value, {dynamic observacion}) {
    List<Widget> badges = [];

    final String val = value == null ? '0' : value.toString();

    if (val == '1') {
      badges.add(_statusBadge('Verificado', Colors.green));
    } else {
      badges.add(_statusBadge('Pendiente', Colors.amber));
    }

    if (observacion != null && observacion.toString().isNotEmpty) {
      final obsStr = observacion.toString();
      if (obsStr.toLowerCase().contains('habilitado')) {
        badges.add(SizedBox(width: 6));
        badges.add(_statusBadge('Habilitado', Colors.green));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label + ':',
              style: TextStyle(
                color: Color(0xFF7e7767),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: badges,
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildObservationBox(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFFfff3cd), // light warning background
        border: Border.all(color: Color(0xFFf0c36d)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFb36b00), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF6b4a00),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

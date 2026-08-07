import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_clock_register.dart';
import 'package:insulog/states/clock_state.dart';

class ClockRecordListWidget extends StatelessWidget {
  final Size size;
  final List<EnumClockRegister> records;
  final ClockState state;
  final bool isLoading;
  final String? errorMessage;

  const ClockRecordListWidget({
    super.key,
    required this.size,
    required this.records,
    required this.state,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null && records.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFD62828)),
        ),
      );
    }

    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text('Nenhum alarme cadastrado.'),
      );
    }

    return Column(
      children: [
        ...records.map(
          (record) => Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.022),
            child: _ClockRecordCard(size: size, record: record, state: state),
          ),
        ),
      ],
    );
  }
}

class _ClockRecordCard extends StatefulWidget {
  final Size size;
  final EnumClockRegister record;
  final ClockState state;

  const _ClockRecordCard({
    required this.size,
    required this.record,
    required this.state,
  });

  @override
  State<_ClockRecordCard> createState() => _ClockRecordCardState();
}

class _ClockRecordCardState extends State<_ClockRecordCard> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(handleStateChange);
  }

  void handleStateChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(handleStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.state.isRecordSelected(widget.record);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        widget.state.onLongPressRecord(widget.record, context, widget.size);
      },
      onTap: () {
        widget.state.onTapRecord(widget.record);
      },
      child: AnimatedScale(
        scale: isSelected ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.size.width * 0.045,
            vertical: widget.size.height * 0.022,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.size.width * 0.05),
            border: Border(),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 104, 104, 104),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: widget.size.width * 0.045,
                height: widget.size.width * 0.045,
                decoration: BoxDecoration(
                  color: widget.record.ativo
                      ? const Color(0xFF3EA75F)
                      : const Color(0xFF9E9E9E),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: widget.size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.state.formataHora(widget.record.dataHora),
                      style: TextStyle(
                        fontSize: widget.size.width * 0.07,
                        color: const Color(0xFF171717),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.state.formataDiasSemana(widget.record.diasSemana),
                      style: TextStyle(
                        fontSize: widget.size.width * 0.038,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.record.ativo ? 'Ativo' : 'Inativo',
                style: TextStyle(
                  fontSize: widget.size.width * 0.038,
                  color: widget.record.ativo
                      ? const Color(0xFF3EA75F)
                      : const Color(0xFF7C7C7C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

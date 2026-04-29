import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputFields extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputFields({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputFields> createState() => _OtpInputFieldsState();
}

class _OtpInputFieldsState extends State<OtpInputFields> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  // Index of the field currently accepting input
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    // Auto-focus the first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < widget.length - 1) {
      setState(() => _activeIndex = index + 1);
      _focusNodes[index + 1].requestFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            right: index < widget.length - 1 ? 8.0 : 0.0,
          ),
          child: SizedBox(
            width: 44,
            height: 44,
            child: IgnorePointer(
              ignoring: index > _activeIndex,
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace &&
                      _controllers[index].text.isEmpty &&
                      index > 0) {
                    _focusNodes[index - 1].requestFocus();
                    _controllers[index - 1].clear();
                    setState(() => _activeIndex = index - 1);
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Noto Sans',
                    color: AppColors.blue950,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: index > _activeIndex
                        ? AppColors.slate100
                        : Colors.white,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: index > _activeIndex
                            ? AppColors.slate200
                            : AppColors.slate300,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.blue700,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => _onChanged(value, index),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

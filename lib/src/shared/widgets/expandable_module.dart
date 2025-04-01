import 'package:flutter/material.dart';

import '../models/module.dart';
class ExpandableModuleWidget extends StatefulWidget {
  final Module module;

  const ExpandableModuleWidget({super.key, required this.module});

  @override
  _ExpandableModuleWidgetState createState() => _ExpandableModuleWidgetState();
}

class _ExpandableModuleWidgetState extends State<ExpandableModuleWidget> {
  bool _isExpanded = false;
  String convertToTime(int minutes) {
    int h = minutes ~/ 60;
    int m = minutes % 60;
    return '${h}h${m}m';
  }
  @override
  Widget build(BuildContext context) {
    final time = convertToTime(widget.module.durationMinutes ?? 0);
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('Module: ${widget.module.orderIndex} '),
                      Text(
                        widget.module.moduleName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                )
              ],
            ),
            if (_isExpanded) ...[
              Text(widget.module.description),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined,color: Colors.blue,),
                  Text(time)
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.menu_book_outlined,color: Colors.blue,),
                  Text( '${widget.module.lessonCount} lesson')
                ],
              )
            ]
          ],
        )
    );
  }
}
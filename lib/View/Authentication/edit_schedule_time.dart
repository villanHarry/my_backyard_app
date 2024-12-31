import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Component/validations.dart';
import 'package:backyard/Model/day_schedule.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TimeSchedulingEditArgument {
  const TimeSchedulingEditArgument({required this.val});

  final DaySchedule val;
}

class TimeSchedulingEditScreen extends StatefulWidget {
  const TimeSchedulingEditScreen({super.key, required this.val});

  final DaySchedule? val;

  @override
  State<TimeSchedulingEditScreen> createState() =>
      _TimeSchedulingEditScreenState();
}

class _TimeSchedulingEditScreenState extends State<TimeSchedulingEditScreen> {
  late DaySchedule? temp = widget.val;
  late bool active = temp?.active ?? false;
  final formatter = NumberFormat('00');
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool errorText = false;

  void nextFunction() {
    errorText = active ? (startTime == null || endTime == null) : false;
    setState(() {});
    if (!errorText) {
      temp?.active = active;
      if (active) {
        temp?.startTime = startTime;
        temp?.endTime = endTime;
      } else {
        temp?.startTime = null;
        temp?.endTime = null;
      }
      Navigator.pop(context, temp);
    }
  }

  @override
  void initState() {
    startTime = widget.val?.startTime;
    endTime = widget.val?.endTime;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: "Time Scheduling",
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      child: CustomPadding(
        horizontalPadding: 4.w,
        topPadding: 0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              headingWidget(),
              const SizedBox(height: 15),
              if (active)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Open Time",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 15),
                      GestureDetector(
                          onTap: () async {
                            final val = await showTimePicker(
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                                barrierColor:
                                    MyColors().primaryColor.withOpacity(.8),
                                context: context,
                                initialTime: TimeOfDay.now());
                            startTime = val;
                            setState(() {});
                          },
                          child: timeField(startTime)),
                      if (errorText && startTime == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Start Time Field can't be empty",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      const Text("Close Time",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 15),
                      GestureDetector(
                          onTap: () async {
                            if (startTime != null) {
                              final val = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (val != null) {
                                final now = DateTime.now();
                                final start = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    startTime?.hour ?? 0,
                                    startTime?.minute ?? 0);
                                final end = DateTime(now.year, now.month,
                                    now.day, val.hour, val.minute);
                                if (end.difference(start).inMinutes > 0) {
                                  endTime = val;
                                  setState(() {});
                                } else {
                                  CustomToast().showToast(
                                      message:
                                          "End Time must be greater than Start Time");
                                }
                              }
                            } else {
                              CustomToast()
                                  .showToast(message: "Select Start Time");
                            }
                          },
                          child: timeField(endTime)),
                      if (errorText && endTime == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "End Time Field can't be empty",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ]),
              bottomBar()
            ],
          ),
        ),
      ),
    );
  }

  Widget timeField(TimeOfDay? time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyTextField(
            readOnly: true,
            enable: false,
            controller: TextEditingController(text: timeFormatterHour(time)),
            hintText: "Hrs",
            width: 100,
            borderRadius: 10),
        Text(":",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        MyTextField(
          controller: TextEditingController(text: timeFormatterMinute(time)),
          readOnly: true,
          hintText: "Mins",
          enable: false,
          width: 100,
          borderRadius: 10,
        ),
        Text(":",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        MyTextField(
          controller: TextEditingController(text: timeFormatterAM(time)),
          readOnly: true,
          enable: false,
          hintText: "AM",
          width: 100,
          borderRadius: 10,
        ),
      ],
    );
  }

  Row headingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(temp?.day.name.titleCase() ?? "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        FlutterSwitch(
            width: 35,
            height: 20,
            toggleSize: 14,
            value: active,
            activeColor: MyColors().primaryColor,
            inactiveColor: const Color(0xFF707070),
            onToggle: (value) {
              active = value;
              setState(() {});
              CustomToast()
                  .showToast(message: "Active: ${value ? "ON" : "OFF"}");
            }),
      ],
    );
  }

  Column bottomBar() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 30),
      MyButton(onTap: nextFunction, title: "Save"),
    ]);
  }

  String timeFormatterHour(TimeOfDay? time) {
    if (time != null) {
      int val = time.hour;
      if (val > 12) {
        val -= 12;
      }
      if (val == 0) {
        val = 12;
      }
      return formatter.format(val);
    } else {
      return "";
    }
  }

  String timeFormatterMinute(TimeOfDay? time) {
    if (time != null) {
      return formatter.format(time.minute);
    } else {
      return "";
    }
  }

  String timeFormatterAM(TimeOfDay? time) {
    if (time != null) {
      // final val = time.hour;
      // if (val > 12) {
      //   return "PM";
      // } else {
      //   return "AM";
      // }
      String value = time?.format(context) ?? "";
      return value.split(":").last.split(" ").last;
    } else {
      return "";
    }
  }
}

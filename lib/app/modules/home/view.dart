import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:taskify/app/core/utils/extensions.dart';
import 'package:taskify/app/core/values/colors.dart';
import 'package:taskify/app/data/models/task.dart';
import 'package:taskify/app/modules/home/controller.dart';
import 'package:taskify/app/modules/home/report/view.dart';
import 'package:taskify/app/modules/home/widgets/add_card.dart';
import 'package:taskify/app/modules/home/widgets/add_dialog.dart';
import 'package:taskify/app/modules/home/widgets/task_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: [
          SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text(
                    "Taskify",
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ...controller.tasks
                          .map((element) => LongPressDraggable(
                              data: element,
                              onDragStarted: () =>
                                  controller.changeDeleting(true),
                              onDraggableCanceled: (_, __) =>
                                  controller.changeDeleting(false),
                              onDragEnd: (_) =>
                                  controller.changeDeleting(false),
                              feedback: Opacity(
                                opacity: 0.8,
                                child: TaskCard(task: element),
                              ),
                              child: TaskCard(task: element)))
                          .toList(),
                      AddCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ReportPage(),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.fade);
                } else {
                  EasyLoading.showInfo('Please create your task type');
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete : Icons.add,
              ),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess("Delete Success");
        },
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  label: 'Home',
                  icon: Padding(
                    padding: EdgeInsets.only(
                      right: 8.0.wp,
                    ),
                    child: const Icon(Icons.apps),
                  )),
              BottomNavigationBarItem(
                  label: 'Report',
                  icon: Padding(
                    padding: EdgeInsets.only(
                      left: 8.0.wp,
                    ),
                    child: const Icon(Icons.data_usage),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

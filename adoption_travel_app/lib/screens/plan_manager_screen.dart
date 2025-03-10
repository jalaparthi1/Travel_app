import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/plan.dart';
import '../widgets/plan_form.dart';

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];
  List<Plan> unassignedPlans = [];

  void _addPlan(
      String name, String description, DateTime date, String priority) {
    setState(() {
      unassignedPlans.add(Plan(
          name: name,
          description: description,
          date: date,
          priority: priority));
      _sortPlansByPriority();
    });
  }

  void _sortPlansByPriority() {
    setState(() {
      plans.sort((a, b) {
        Map<String, int> priorityValue = {"High": 3, "Medium": 2, "Low": 1};
        return priorityValue[b.priority]!.compareTo(priorityValue[a.priority]!);
      });
    });
  }

  void _assignPlanToList(Plan plan) {
    setState(() {
      unassignedPlans.remove(plan);
      plans.add(plan);
      _sortPlansByPriority();
    });
  }

  void _deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
    });
  }

  void _editPlan(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return PlanForm((newName, newDescription, newDate, newPriority) {
          setState(() {
            plans[index].name = newName;
            plans[index].description = newDescription;
            plans[index].date = newDate;
            plans[index].priority = newPriority;
            _sortPlansByPriority();
          });
        });
      },
    );
  } // ✅ Closing bracket added here

  void _openPlanForm() {
    showDialog(
      context: context,
      builder: (ctx) => PlanForm(_addPlan),
    );
  }

  Color _getPlanColor(Plan plan) {
    if (plan.isCompleted) return Colors.green[300]!;
    return Colors.amber[300]!;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ build method was missing!
    return Scaffold(
      appBar: AppBar(title: Text("Plan Manager")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _openPlanForm,
            child: Text("Create Plan", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          ),
          Expanded(
            child: DragTarget<Plan>(
              onAccept: (plan) => _assignPlanToList(plan),
              builder: (context, candidateData, rejectedData) =>
                  ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return GestureDetector(
                    onDoubleTap: () => _deletePlan(index),
                    onLongPress: () => _editPlan(index),
                    child: Draggable<Plan>(
                      data: plan,
                      feedback: Material(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: _getPlanColor(plan),
                          child:
                              Text(plan.name, style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      child: Slidable(
                        key: Key(plan.name),
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (ctx) => _toggleCompletion(index),
                              backgroundColor: Colors.green,
                              icon: Icons.check,
                              label: 'Complete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(plan.name,
                              style: TextStyle(
                                  decoration: plan.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null)),
                          subtitle: Text(
                              "${plan.description} - ${plan.date.toLocal()}"),
                          trailing: Text(plan.priority,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          tileColor: _getPlanColor(plan),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue[100],
            child: Column(
              children: [
                Text("Drag plans here to assign them",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 10,
                  children: unassignedPlans.map((plan) {
                    return Draggable<Plan>(
                      data: plan,
                      feedback: Material(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: _getPlanColor(plan),
                          child:
                              Text(plan.name, style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: _getPlanColor(plan),
                        child: Text(plan.name),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

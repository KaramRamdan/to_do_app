import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit.dart';


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  VoidCallback? onTap,
  required FormFieldValidator<String>? onValidate,
  VoidCallback? suffixPressed,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (s) {
        onSubmit;
      },
      onChanged: (s) {
        onChanged;
      },
      onTap: onTap,
      validator: onValidate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) =>
Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.grey[500],
          child: Text(
            '${model['time']}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context)
                .updateData(status: 'done', id: model['id']);
          },
          icon: Icon(
            Icons.check_box_rounded,
            color: Colors.grey[700],
          ),
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context)
                .updateData(status: 'archive', id: model['id']);
          },
          icon: Icon(
            Icons.archive_rounded,
            color: Colors.grey[700],
          ),
        ),
      ],
    ),
  ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuilder({required List<Map> tasks}) =>
    ConditionalBuilder(
  condition: tasks.length > 0,
  fallback: (BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          ' No Tasks Yet, Please Add Some Tasks ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
  builder: (BuildContext context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
);

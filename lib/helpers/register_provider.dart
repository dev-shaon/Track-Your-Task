import 'package:provider/provider.dart';
import 'package:track_your_task/features/add_task/viewmodel/task_viewmodel.dart';
import 'package:track_your_task/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:track_your_task/features/auth/viewmodel/signin_viewmodel.dart';

var providers = [
  ChangeNotifierProvider<AuthViewModel>(create: (context) => AuthViewModel()),
  ChangeNotifierProvider<SigninViewModel>(create: (context) => SigninViewModel()),
  ChangeNotifierProvider<TaskViewModel>(create: (context) => TaskViewModel()),
];

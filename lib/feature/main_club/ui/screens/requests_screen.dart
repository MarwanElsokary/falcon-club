import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falconclubapp/core/thems/thems.dart';

import '../../cubit/requests_cubit.dart';
import '../../cubit/requests_state.dart';
import '../widget/requests_app_bar.dart';
import '../widget/requests_list.dart';
import '../widget/requests_tab_selector.dart';


class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestsCubit>().fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestsCubit, RequestsState>(
      listener: (context, state) {
        if (state is RequestActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تمت العملية بنجاح'),
              backgroundColor: mainColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (state is RequestActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: whiteclr,
        body: Column(
          children: [
            const RequestsAppBar(),
            const SizedBox(height: 4),
            const RequestsTabSelector(),
            const SizedBox(height: 8),
            const Expanded(child: RequestsList()),
          ],
        ),
      ),
    );
  }
}

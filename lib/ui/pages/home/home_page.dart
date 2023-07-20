import 'package:auto_route/annotations.dart';
import 'package:currency_app/app/services/exchanged_service.dart';
import 'package:currency_app/ui/pages/home/home_page_controller.dart';
import 'package:currency_app/ui/ui.dart';
import 'package:date_time/date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';

import '../../widgets/widgets.dart';

@RoutePage()
class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  static const _headerDatesStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const _dateFormat = 'dd.MM.yy';

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсы валют'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: c.changeRateDatesMode,
            icon: const Icon(Icons.published_with_changes_rounded),
          ),
          IconButton(
            onPressed: c.goToSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          _datesHeader(),
          Expanded(child: _currenciesList()),
        ],
      ),
    );
  }

  Widget _datesHeader() {
    return Container(
      color: Colors.purple,
      height: 50,
      child: Row(
        children: [
          UI.spacer,
          Expanded(
            child: Obx(() {
              final mode = c.datesMode;

              final today = Date.today().format(_dateFormat); // ?? 'Today'
              final yesterday =
                  Date.yesterday().format(_dateFormat); // ?? 'Yesterday'
              final tomorrow =
                  Date.tomorrow().format(_dateFormat); // ?? 'Tomorrow'

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    mode == RateDatesMode.yesterday ? yesterday : today,
                    style: _headerDatesStyle,
                  ),
                  Text(
                    mode == RateDatesMode.tomorrow ? tomorrow : today,
                    style: _headerDatesStyle,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _currenciesList() {
    return StreamBuilder<List<ExchangedRatesModelPair>>(
      stream: c.currencyRatePairsToShow$,
      builder: (context, snapshot) {
        return Obx(
          () {
            final mode = c.datesMode;
            return ListView.separated(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (_, index) {
                final pair = snapshot.data![index];
                return CurrencyPairView(pair, mode: mode);
              },
              separatorBuilder: (_, __) => const Divider(),
            );
          },
        );
      },
    );
  }
}

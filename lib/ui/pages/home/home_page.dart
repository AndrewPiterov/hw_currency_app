import 'package:auto_route/annotations.dart';
import 'package:currency_app/app/services/exchanged_service.dart';
import 'package:currency_app/ui/pages/home/home_page_controller.dart';
import 'package:currency_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';

@RoutePage()
class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсы валют'),
        actions: [
          IconButton(
            onPressed: c.goToSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          _datesHeader(),
          Expanded(child: _currneciesList()),
        ],
      ),
    );
  }

  Widget _datesHeader() {
    return const SizedBox(
      height: 50,
      child: Row(
        children: [
          UI.spacer,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '19.07.23',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '20.07.23',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currneciesList() {
    return StreamBuilder<List<ExchangedRatesModelPair>>(
      stream: c.currencyRatePairsToShow$,
      builder: (context, snapshot) {
        return ListView.separated(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (_, index) {
            final pair = snapshot.data![index];
            return CurrencyPairView(pair);
          },
          separatorBuilder: (_, __) => const Divider(),
        );
      },
    );
  }
}

class CurrencyPairView extends StatelessWidget {
  const CurrencyPairView(this.pair, {super.key});

  final ExchangedRatesModelPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.abbr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${pair.scale} ${pair.currency}'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(pair.yesterday?.rates.toString() ?? '-'),
                Text(pair.today?.rates.toString() ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
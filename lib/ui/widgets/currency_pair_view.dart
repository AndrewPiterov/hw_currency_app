import 'package:currency_app/app/app.dart';
import 'package:currency_app/ui/pages/home/home_page_controller.dart';
import 'package:flutter/material.dart';

class CurrencyPairView extends StatelessWidget {
  const CurrencyPairView(
    this.pair, {
    super.key,
    this.mode = RateDatesMode.tomorrow,
  });

  final ExchangedRatesModelPair pair;
  final RateDatesMode mode;

  double get _first =>
      (mode == RateDatesMode.yesterday ? pair.yesterday : pair.today)!.rates;

  double get _last =>
      (mode == RateDatesMode.tomorrow ? pair.tomorrow : pair.today)!.rates;

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
                Text(_first.toString()),
                Text(_last.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurrencySettingView extends StatefulWidget {
  const CurrencySettingView(
    this.pair, {
    this.initialState = false,
    required this.onChanged,
    super.key,
  });

  final ExchangedRatesModel pair;
  final bool initialState;

  final void Function(bool) onChanged;

  @override
  State<CurrencySettingView> createState() => _CurrencySettingViewState();
}

class _CurrencySettingViewState extends State<CurrencySettingView> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialState;
  }

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
                  widget.pair.abbr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${widget.pair.scale} ${widget.pair.currency}'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Switch.adaptive(
                  value: _isSelected,
                  onChanged: (isSelected) {
                    setState(() {
                      _isSelected = isSelected;
                    });
                    widget.onChanged(isSelected);
                  },
                ),
                const Icon(Icons.drag_handle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

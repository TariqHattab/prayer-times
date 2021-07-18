import 'package:flutter/material.dart';

class TimingsTable extends StatelessWidget {
  const TimingsTable({
    Key key,
    @required List<DataRow> Function(BuildContext) buildListOfDataRaw,
    @required this.size,
    this.timingsLength,
  })  : _buildListOfDataRaw = buildListOfDataRaw,
        super(key: key);

  final List<DataRow> Function(BuildContext) _buildListOfDataRaw;
  final Size size;
  final int timingsLength;

  @override
  Widget build(BuildContext context) {
    double rowHeight = size.height / (timingsLength + 1);
    return DataTable(
      dataRowHeight: rowHeight,
      columns: [
        DataColumn(
          label: Text(
            'Prayers',
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 28),
          ),
        ),
        DataColumn(
          label: Text(
            'Timings',
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 28),
          ),
        ),
      ],
      rows: _buildListOfDataRaw(context),
    );
  }
}

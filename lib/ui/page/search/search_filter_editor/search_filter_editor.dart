/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:search_filter_editor.dart
 * 创建时间:2021/9/3 下午11:18
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/model/dropdown_item.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/dropdown_menu.dart';
import 'package:pixiv_func_android/view_model/search_filter_model.dart';

class SearchFilterEditor extends StatelessWidget {
  final SearchFilter filter;
  final ValueChanged<SearchFilter> onChanged;

  SearchFilterEditor({Key? key, required this.filter, required this.onChanged}) : super(key: key);

  void _openStartDatePicker(BuildContext context, SearchFilterModel model) {
    showDatePicker(
      context: context,
      initialDate: model.dateTimeRange.start,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = model.dateTimeRange;
        //+1年
        final valuePlus1 = DateTime(value.year + 1, value.month, value.day);
        if (temp.end.isAfter(valuePlus1) || value.isAfter(temp.end)) {
          //start差距大于1年
          model.dateTimeRange = DateTimeRange(
            start: value,
            end: model.currentDate.isAfter(valuePlus1) ? valuePlus1 : model.currentDate,
          );
        } else {
          //start差距小于1年
          model.dateTimeRange = DateTimeRange(start: value, end: temp.end);
        }
      }
    });
  }

  void _openEndDatePicker(BuildContext context, SearchFilterModel model) {
    showDatePicker(
      context: context,
      initialDate: model.dateTimeRange.end,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = model.dateTimeRange;
        //-1年
        final minus1 = DateTime(value.year - 1, value.month, value.day);
        if (temp.start.isBefore(minus1) || value.isBefore(temp.start)) {
          //end差距大于1年
          model.dateTimeRange = DateTimeRange(start: minus1, end: value);
        } else {
          //end差距小于1年
          model.dateTimeRange = DateTimeRange(start: temp.start, end: value);
        }
      }
    });
  }

  Widget _buildSearchSortEdit(SearchFilterModel model) {
    return ListTile(
      title: Text('搜索排序'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownMenu<SearchSort>(
          menuItems: [
            DropdownItem(SearchSort.DATE_DESC, '时间降序'),
            DropdownItem(SearchSort.DATE_ASC, '时间升序'),
          ],
          currentValue: model.sort,
          onChanged: (SearchSort? value) {
            model.sort = value!;
          },
        ),
      ),
    );
  }

  Widget _buildSearchTargetEdit(SearchFilterModel model) {
    return ListTile(
      title: Text('搜索方式'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownMenu<SearchTarget>(
          menuItems: [
            DropdownItem(SearchTarget.PARTIAL_MATCH_FOR_TAGS, '标签(部分匹配)'),
            DropdownItem(SearchTarget.EXACT_MATCH_FOR_TAGS, '标签(完全匹配)'),
            DropdownItem(SearchTarget.TITLE_AND_CAPTION, '标签&简介'),
          ],
          currentValue: model.target,
          onChanged: (SearchTarget? value) {
            model.target = value!;
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeTypeEdit(SearchFilterModel model) {
    return ListTile(
      title: Text('时间范围'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownMenu<int>(
          menuItems: [
            DropdownItem(0, '不限'),
            DropdownItem(1, '一天内'),
            DropdownItem(2, '一周内'),
            DropdownItem(3, '一月内'),
            DropdownItem(4, '半年内'),
            DropdownItem(5, '一年内'),
            DropdownItem(-1, '自定义'),
          ],
          currentValue: model.dateTimeRangeType,
          onChanged: (int? value) {
            model.dateTimeRangeType = value!;
            if (!model.enableDateRange && value != 0) {
              model.enableDateRange = true;
            }
            switch (value) {
              case 0:
                model.enableDateRange = false;
                break;
              case 1:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(Duration(days: 1)),
                  end: model.currentDate,
                );
                break;
              case 2:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(Duration(days: 7)),
                  end: model.currentDate,
                );
                break;
              case 3:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(Duration(days: 30)),
                  end: model.currentDate,
                );
                break;
              case 4:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(Duration(days: 182)),
                  end: model.currentDate,
                );
                break;
              case 5:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(Duration(days: 365)),
                  end: model.currentDate,
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeEdit(BuildContext context, SearchFilterModel model) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _openStartDatePicker(context, model),
            child: Text(
              model.startDate,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Text(' 到 '),
          InkWell(
            onTap: () => _openEndDatePicker(context, model),
            child: Text(
              model.endDate,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchFilterModel(filter: filter),
      builder: (BuildContext context, SearchFilterModel model, Widget? child) {
        return Container(
          height: 430,
          padding: EdgeInsets.all(35),
          child: Column(
            children: [
              _buildSearchSortEdit(model),
              _buildSearchTargetEdit(model),
              _buildDateRangeTypeEdit(model),
              model.dateTimeRangeType == -1 ? _buildDateRangeEdit(context, model) : Container(),
              Text(model.bookmarkTotalText),
              Slider(
                value: model.bookmarkTotalSelected.toDouble(),
                min: 0,
                max: model.bookmarkTotalItems.length - 1,
                onChanged: (double value) {
                  model.bookmarkTotalSelected = value.round();
                },
              ),
              OutlinedButton(
                onPressed: () {
                  onChanged(model.filter);
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              ),
            ],
          ),
        );
      },
    );
  }
}

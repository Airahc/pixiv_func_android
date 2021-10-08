/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_filter_editor.dart
 * 创建时间:2021/9/3 下午11:18
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/dropdown_item.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/dropdown_menu.dart';
import 'package:pixiv_func_android/ui/widget/sliding_segmented_control.dart';
import 'package:pixiv_func_android/view_model/search_filter_model.dart';

class SearchFilterEditor extends StatelessWidget {
  final SearchFilter filter;
  final ValueChanged<SearchFilter> onChanged;

  const SearchFilterEditor({Key? key, required this.filter, required this.onChanged}) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SlidingSegmentedControl(
        children: const <SearchSort, Widget>{
          SearchSort.dateDesc: Text('时间降序'),
          SearchSort.dateAsc: Text('时间升序'),
          SearchSort.popularDesc: Text('热度降序'),
        },
        groupValue: model.sort,
        onValueChanged: (SearchSort? value) {
          if (null != value) {
            if (SearchSort.popularDesc == value && !accountManager.current!.user.isPremium) {
              platformAPI.toast('你不是Pixiv高级会员,所以该选项与时间降序行为一致');
            }
            model.sort = value;
          }
        },
      ),
    );
  }

  Widget _buildSearchTargetEdit(SearchFilterModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SlidingSegmentedControl(
        children: const <SearchTarget, Widget>{
          SearchTarget.partialMatchForTags: Text('标签(部分匹配)'),
          SearchTarget.exactMatchForTags: Text('标签(完全匹配)'),
          SearchTarget.titleAndCaption: Text('标签&简介'),
        },
        groupValue: model.target,
        onValueChanged: (SearchTarget? value) {
          if (null != value) {
            model.target = value;
          }
        },
      ),
    );
  }

  Widget _buildDateRangeTypeEdit(SearchFilterModel model) {
    return ListTile(
      title: const Text('时间范围'),
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
                  start: model.currentDate.subtract(const Duration(days: 1)),
                  end: model.currentDate,
                );
                break;
              case 2:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(const Duration(days: 7)),
                  end: model.currentDate,
                );
                break;
              case 3:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(const Duration(days: 30)),
                  end: model.currentDate,
                );
                break;
              case 4:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(const Duration(days: 182)),
                  end: model.currentDate,
                );
                break;
              case 5:
                model.dateTimeRange = DateTimeRange(
                  start: model.currentDate.subtract(const Duration(days: 365)),
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
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
          const Text(' 到 '),
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
      model: SearchFilterModel(filter),
      builder: (BuildContext context, SearchFilterModel model, Widget? child) {
        return Container(
          height: 450,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              _buildSearchSortEdit(model),
              _buildSearchTargetEdit(model),
              const Divider(),
              Text(model.bookmarkTotalText),
              Slider(
                value: model.bookmarkTotalSelected.toDouble(),
                min: 0,
                max: model.bookmarkTotalItems.length - 1,
                divisions: model.bookmarkTotalItems.length - 1,
                onChanged: (double value) {
                  model.bookmarkTotalSelected = value.round();
                },
              ),
              const Divider(),
              _buildDateRangeTypeEdit(model),
              Visibility(
                visible: model.dateTimeRangeType == -1,
                child: _buildDateRangeEdit(context, model),
              ),
              OutlinedButton(
                onPressed: () {
                  onChanged(model.filter);
                  Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      },
    );
  }
}

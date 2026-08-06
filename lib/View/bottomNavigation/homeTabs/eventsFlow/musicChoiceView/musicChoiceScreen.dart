import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Draft icon shown in the app-bar when editing is not in progress.
Widget _draftAction(
    EventController controller, BuildContext context, ThemeData theme) {
  if (controller.eventDetail != null ||
      controller.draftCondition.value == false) {
    return const SizedBox.shrink();
  }
  return GestureDetector(
    onTap: () => controller.postEventFunction(context, theme, draft: true),
    child: const Padding(
      padding: EdgeInsets.only(right: 8),
      child: Icon(Icons.drafts),
    ),
  );
}

/// Horizontal chip row for selected tags / activities.
Widget _selectedChipsRow(BuildContext context, List items) {
  if (items.isEmpty) return const SizedBox.shrink();
  return SizedBox(
    height: kToolbarHeight,
    child: Align(
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: _styledChip(
            context,
            items[i].name.toString(),
          ),
        ),
      ),
    ),
  );
}

/// A styled white chip with rounded corners.
Widget _styledChip(BuildContext context, String label, {ThemeData? theme}) {
  return Chip(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    backgroundColor: DynamicColor.whiteClr,
    label: Text(
      label,
      style: poppinsRegularStyle(
        fontSize: 12,
        context: context,
        color: theme?.scaffoldBackgroundColor,
      ),
    ),
  );
}

/// Expandable category list with checkboxes for sub-items.
class _ExpandableCategoryList extends StatelessWidget {
  const _ExpandableCategoryList({
    required this.items,
    required this.onToggleCategory,
    required this.onCheckItem,
  });

  final List items;
  final void Function(int index) onToggleCategory;
  final void Function({required dynamic items, required bool? value})
      onCheckItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: items.isEmpty
          ? noData(theme: theme)
          : ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    // ── Category header ──────────────────────────────
                    GestureDetector(
                      onTap: () => onToggleCategory(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DynamicColor.darkGrayClr,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              items[index].name.toString(),
                              style: poppinsRegularStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                            Icon(
                              items[index].showSubCat!.value
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_sharp,
                              color: DynamicColor.whiteClr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ── Sub-items ────────────────────────────────────
                    Visibility(
                      visible: items[index].showSubCat!.value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: DynamicColor.darkGrayClr,
                          ),
                          child: ListView.builder(
                            itemCount: items[index].categoryItems!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, subIndex) {
                              final item =
                                  items[index].categoryItems![subIndex];
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: DynamicColor.darkGrayClr,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.name.toString(),
                                          style: poppinsRegularStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            context: context,
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: Colors.white,
                                          ),
                                          child: Checkbox(
                                            activeColor: DynamicColor.yellowClr,
                                            value: item.selected!.value,
                                            onChanged: (v) => onCheckItem(
                                                items: item, value: v),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (subIndex <
                                      items[index].categoryItems!.length - 1)
                                    Divider(color: DynamicColor.whiteClr),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MusicChoiceScreen
// ─────────────────────────────────────────────────────────────────────────────

class MusicChoiceScreen extends StatelessWidget {
  MusicChoiceScreen({super.key});

  final EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: 'Create Event',
        actions: [_draftAction(_controller, context, theme)],
      ),
      body: GetBuilder<EventController>(
        initState: (_) {
          // Edit flow only (not create/duplicate/draft): re-seed manuals
          // when the editor is still empty so collection-less events show
          // their saved manual hashtags.
          final isEditing = _controller.eventDetail != null &&
              !_controller.duplicateValue.value &&
              !_controller.draftValue.value;
          if (isEditing &&
              !_controller.manualHashtagsChanged &&
              _controller.manualHashtags.isEmpty) {
            _controller.seedHashtagsFromEventDetail();
          }
          _controller.getHashtagCollectionApi();
          _controller.collectionSelectionChanged = false;
        },
        builder: (controller) {
          if (!controller.getMusicHashTagLoader.value) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    context: context,
                    theme: theme,
                    title: 'Event Hashtags',
                    subtitle:
                        'Type event-only hashtags, add saved collections, or use both.',
                  ),
                  _ManualHashtagEditor(controller: controller),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Collections',
                        style: poppinsRegularStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Get.toNamed(Routes.myTagCollection)!.then((_) {
                            _controller.getHashtagCollectionApi();
                          });
                        },
                        icon: Icon(Icons.add, color: DynamicColor.yellowClr),
                        label: Text(
                          'Add a Collection',
                          style: poppinsRegularStyle(
                            fontSize: 12,
                            context: context,
                            color: DynamicColor.yellowClr,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _SelectedCollectionList(controller: controller),
                  if (controller.hashtagCollectionError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      controller.hashtagCollectionError!,
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: DynamicColor.lightRedClr,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _continueBar(
        onTap: () async {
          if (_controller.hasOrganizerHashtagSource) {
            await _controller.getMusicTag(type: 'activity_choice');
            Get.toNamed(Routes.activityChoiceScreen);
          } else {
            bottomToast(
              text:
                  'Please add a manual hashtag or select a hashtag collection',
            );
          }
        },
      ),
    );
  }
}

class _ManualHashtagEditor extends StatelessWidget {
  const _ManualHashtagEditor({required this.controller});

  final EventController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manual Hashtags',
          style: poppinsRegularStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            context: context,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: DynamicColor.darkGrayClr,
          ),
          child: TextField(
            controller: controller.manualHashtagController,
            style: poppinsRegularStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Add #hashtags, comma separated',
              hintStyle: poppinsRegularStyle(
                fontSize: 13,
                context: context,
                color: DynamicColor.lightRedClr,
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: controller.addManualHashtagText,
            onChanged: (value) {
              if (value.contains(',')) controller.addManualHashtagText(value);
            },
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.manualHashtags
              .map(
                (tag) => Chip(
                  backgroundColor: DynamicColor.whiteClr,
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.removeManualHashtag(tag),
                  label: Text(
                    '#$tag',
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SelectedCollectionList extends StatelessWidget {
  const _SelectedCollectionList({required this.controller});

  final EventController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.selectedOrganizerCollections.isEmpty) {
      return Center(child: noData(theme: theme));
    }
    return Column(
      children: controller.selectedOrganizerCollections.map((collection) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: DynamicColor.darkGrayClr,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        collection.title,
                        style: poppinsRegularStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          controller.removeSelectedCollection(collection),
                      child: Text(
                        'Remove Collection',
                        style: poppinsRegularStyle(
                          fontSize: 11,
                          context: context,
                          color: DynamicColor.lightRedClr,
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: collection.hashtags
                      .map(
                        (tag) => Chip(
                          avatar: const Icon(Icons.lock, size: 14),
                          backgroundColor: DynamicColor.whiteClr,
                          label: Text(
                            tag.displayName,
                            style: poppinsRegularStyle(
                              fontSize: 12,
                              context: context,
                              color: theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (collection.hashtags.isEmpty)
                  Text(
                    'No hashtags returned for this collection',
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: DynamicColor.lightRedClr,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ActivityChoiceScreen
// ─────────────────────────────────────────────────────────────────────────────

class ActivityChoiceScreen extends StatelessWidget {
  ActivityChoiceScreen({super.key});

  final EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: 'Create Event',
        actions: [_draftAction(_controller, context, theme)],
      ),
      body: GetBuilder<EventController>(
        initState: (_) => _controller.eventDetail != null
            ? _controller.activityChoice()
            : _controller.getMusicTag(type: 'activity_choice'),
        builder: (controller) {
          if (!controller.getMusicTagLoader.value) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    context: context,
                    theme: theme,
                    title: 'Activity Choice!',
                    subtitle:
                        'Adding Tags to your proposal will give the Groovkin community a better understanding of your event!',
                  ),
                  _selectedChipsRow(context, controller.activityListPost),
                  _ExpandableCategoryList(
                    items: controller.activityList,
                    onToggleCategory: (i) {
                      controller.activityList[i].showSubCat!.value =
                          !controller.activityList[i].showSubCat!.value;
                      controller.update();
                    },
                    onCheckItem: ({required items, required value}) =>
                        controller.activityAddFtn(items: items, value: value),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _continueBar(
        onTap: () {
          // Activity Choice is optional — allow continue with zero selections.
          _controller.imageListtt.clear();
          _controller.removeImageList.clear();
          if (_controller.eventDetail != null) {
            for (final ele
                in _controller.eventDetail!.data!.profilePicture!) {
              _controller.imageListtt.add(ele);
            }
          }
          _controller.update();
          Get.toNamed(Routes.commentsAndAttachment);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SaveHashTagScreen
// ─────────────────────────────────────────────────────────────────────────────

class SaveHashTagScreen extends StatelessWidget {
  SaveHashTagScreen({super.key});

  final EventController _controller = Get.find();
  final bool hashTag = Get.arguments['musicHashTag'];
  final List selectedHashList = [];

  final List<ListClass> listA = [
    ListClass(text: "90's Hip Hop Party", condition: false.obs),
    ListClass(text: 'for  night party ', condition: false.obs),
    ListClass(text: 'for birthday', condition: false.obs),
    ListClass(text: 'for  night party ', condition: false.obs),
    ListClass(text: "90's Hip Hop Party", condition: false.obs),
    ListClass(text: 'for  night party ', condition: false.obs),
    ListClass(text: 'for birthday', condition: false.obs),
    ListClass(text: 'for  night party ', condition: false.obs),
  ];

  static const _staticTags = [
    '#Pooltable',
    '#Billiards',
    '#Tequla',
    '#8Ball',
    '#TacoTuesday',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Save Hashtag'),
      body: GetBuilder<EventController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              // ── Static chips ────────────────────────────────────────
              Wrap(
                children: _staticTags
                    .map((tag) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _styledChip(context, tag, theme: theme),
                        ))
                    .toList(),
              ),
              // ── List ────────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  itemCount: listA.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            listA[index].text.toString(),
                            style: poppinsRegularStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              activeColor: DynamicColor.yellowClr,
                              value: listA[index].condition!.value,
                              onChanged: (v) {
                                selectedHashList.contains(listA[index].text)
                                    ? selectedHashList.remove(listA[index].text)
                                    : selectedHashList.add(listA[index].text);
                                listA[index].condition!.value = v!;
                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // ── Save button ─────────────────────────────────────────
              Visibility(
                visible: selectedHashList.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: CustomButton(
                    heights: 30,
                    widths: Get.width / 2.1,
                    borderClr: Colors.transparent,
                    bgImage: 'assets/grayClor.png',
                    backgroundClr: true,
                    onTap: () {},
                    text: 'Save',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () => Get.toNamed(Routes.createNewHashTagScreen),
            text: 'Create new Collection',
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CreateNewHashTagScreen
// ─────────────────────────────────────────────────────────────────────────────

class CreateNewHashTagScreen extends StatelessWidget {
  CreateNewHashTagScreen({super.key});

  final List<String> _myListCustom = [];
  final TextEditingController _hashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'New Hashtag'),
      body: GetBuilder<EventController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: DynamicColor.avatarBgClr,
                  ),
                  child: TextFormField(
                    controller: _hashController,
                    style: poppinsRegularStyle(
                      fontSize: 14,
                      color: theme.primaryColor,
                      context: context,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'here',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && v.contains(' ')) {
                        _myListCustom.add(v);
                        _hashController.clear();
                        controller.update();
                      }
                    },
                  ),
                ),
              ),
              Wrap(
                children: _myListCustom
                    .map((tag) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _styledChip(context, tag, theme: theme),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: Get.back,
            text: 'Save',
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private layout helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Centered title + subtitle header used in both hashtag screens.
Widget _sectionHeader({
  required BuildContext context,
  required ThemeData theme,
  required String title,
  required String subtitle,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: poppinsRegularStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: poppinsRegularStyle(
          fontSize: 12,
          context: context,
          color: DynamicColor.lightRedClr,
        ),
      ),
    ],
  );
}

/// Standard bottom "Continue" bar shared by both tag screens.
Widget _continueBar({required VoidCallback onTap}) {
  return SafeArea(
    bottom: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: CustomButton(
        borderClr: Colors.transparent,
        onTap: onTap,
        text: 'Continue',
      ),
    ),
  );
}

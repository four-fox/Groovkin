import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/hashtagCollectionModel.dart';

class MyTagCollection extends StatefulWidget {
  const MyTagCollection({super.key});

  @override
  State<MyTagCollection> createState() => _MyTagCollectionState();
}

class _MyTagCollectionState extends State<MyTagCollection> {
  final EventController _eventController = Get.find();
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<EventController>(
      initState: (_) => _eventController.getEventTagCollection(),
      builder: (controller) {
        final filtered = selectedType == null
            ? controller.organizerCollections
            : controller.organizerCollections
                .where((collection) => collection.type == selectedType)
                .toList();
        return Scaffold(
          appBar: customAppBar(theme: theme, text: 'My Tag Collection'),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RefreshIndicator(
              onRefresh: () async =>
                  controller.getEventTagCollection(type: selectedType),
              child: ListView(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Collections',
                    style: poppinsMediumStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FilterBar(
                    selectedType: selectedType,
                    onChanged: (type) => setState(() => selectedType = type),
                  ),
                  const SizedBox(height: 12),
                  if (!controller.getMyTagCollectionLoader.value)
                    const SizedBox(
                      height: 180,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.hashtagCollectionError != null)
                    _MessageState(
                      text: controller.hashtagCollectionError!,
                      actionText: 'Retry',
                      onTap: () =>
                          controller.getEventTagCollection(type: selectedType),
                    )
                  else if (filtered.isEmpty)
                    _MessageState(
                      text: 'No collections yet',
                      actionText: 'Add New Collection',
                      onTap: () => _openCreate(),
                    )
                  else
                    ...filtered.map(
                      (collection) => _CollectionCard(
                        collection: collection,
                        selected: controller.selectedOrganizerCollections
                            .any((item) => item.id == collection.id),
                        onChanged: (value) =>
                            controller.toggleOrganizerCollection(
                          collection,
                          value ?? false,
                        ),
                        onEdit: () => Get.toNamed(
                          Routes.createNewTag,
                          arguments: {'collection': collection},
                        )?.then((_) => controller.getEventTagCollection(
                              type: selectedType,
                            )),
                        onOpen: () => Get.toNamed(
                          Routes.myCollectionDetailsScreen,
                          arguments: {'id': collection.id},
                        ),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      borderClr: Colors.transparent,
                      color1: DynamicColor.blackClr,
                      color2: DynamicColor.blackClr,
                      onTap: _openCreate,
                      text: 'Add New Collection',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      borderClr: Colors.transparent,
                      onTap: Get.back,
                      text: 'Add to Event',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openCreate() {
    Get.toNamed(Routes.createNewTag)?.then(
      (_) => _eventController.getEventTagCollection(type: selectedType),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selectedType, required this.onChanged});

  final String? selectedType;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('All'),
          selected: selectedType == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final type in HashtagCollectionType.values)
          ChoiceChip(
            label: Text(type.label),
            selected: selectedType == type.apiValue,
            onSelected: (_) => onChanged(type.apiValue),
          ),
      ],
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.collection,
    required this.selected,
    required this.onChanged,
    required this.onEdit,
    required this.onOpen,
  });

  final HashtagCollection collection;
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: DynamicColor.darkGrayClr,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                  ),
                  Checkbox(
                    activeColor: DynamicColor.yellowClr,
                    value: selected,
                    onChanged: collection.isActive ? onChanged : null,
                  ),
                ],
              ),
              Text(
                '${collection.typeLabel} • ${collection.hashtagsCount} hashtags • ${collection.eventsCount} events${collection.isActive ? '' : ' • inactive'}',
                style: poppinsRegularStyle(
                  fontSize: 11,
                  context: context,
                  color: DynamicColor.lightRedClr,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: collection.hashtags
                    .map(
                      (tag) => Chip(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            heights: 36,
            widths: Get.width / 2,
            borderClr: Colors.transparent,
            onTap: onTap,
            text: actionText,
          ),
        ],
      ),
    );
  }
}

class MyCollectionDetailsScreen extends StatefulWidget {
  const MyCollectionDetailsScreen({super.key});

  @override
  State<MyCollectionDetailsScreen> createState() =>
      _MyCollectionDetailsScreenState();
}

class _MyCollectionDetailsScreenState extends State<MyCollectionDetailsScreen> {
  int? id = Get.arguments?['id'];
  final _eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<EventController>(
      initState: (_) => _eventController.getEventTagDetail(id: id),
      builder: (controller) {
        final collection = controller.tagCollectionDetail;
        return Scaffold(
          appBar: customAppBar(theme: theme, text: 'My Collection'),
          body: !controller.getTagCollectionDetails.value
              ? const Center(child: CircularProgressIndicator())
              : collection == null
                  ? Center(child: noData(context: context, theme: theme))
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListView(
                        children: [
                          Text(
                            collection.title,
                            style: poppinsMediumStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${collection.typeLabel} • ${collection.eventsCount} events',
                            style: poppinsRegularStyle(
                              fontSize: 12,
                              context: context,
                              color: DynamicColor.lightRedClr,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: collection.hashtags
                                .map(
                                  (tag) => Chip(label: Text(tag.displayName)),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
          bottomNavigationBar: collection == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            borderClr: Colors.transparent,
                            onTap: () => Get.toNamed(
                              Routes.createNewTag,
                              arguments: {'collection': collection},
                            )?.then((_) => controller.getEventTagDetail(
                                id: collection.id)),
                            text: 'Edit',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomButton(
                            borderClr: Colors.transparent,
                            color1: DynamicColor.redClr,
                            color2: DynamicColor.redClr,
                            onTap: () async {
                              if (collection.id != null) {
                                await controller.removeTagCollection(
                                  collectionIds: [collection.id!],
                                );
                                Get.back();
                              }
                            },
                            text: 'Remove',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class CreateNewTag extends StatefulWidget {
  const CreateNewTag({super.key});

  @override
  State<CreateNewTag> createState() => _CreateNewTagState();
}

class _CreateNewTagState extends State<CreateNewTag> {
  HashtagCollection? collection = Get.arguments?['collection'];
  late final TextEditingController titleController;
  late final TextEditingController hashtagsController;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: collection?.title);
    hashtagsController = TextEditingController(
      text: collection?.hashtags.map((tag) => tag.name).join(', '),
    );
    selectedType = collection?.type ?? HashtagCollectionType.music.apiValue;
  }

  @override
  void dispose() {
    titleController.dispose();
    hashtagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<EventController>(
      builder: (controller) {
        final parsedTags = parseHashtagText(hashtagsController.text);
        return Scaffold(
          appBar: customAppBar(
            theme: theme,
            text: collection == null ? 'New Collection' : 'Edit Collection',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                _InputBox(
                  controller: titleController,
                  hintText: 'Collection title',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  dropdownColor: DynamicColor.darkGrayClr,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: HashtagCollectionType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type.apiValue,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedType = value);
                  },
                ),
                const SizedBox(height: 12),
                _InputBox(
                  controller: hashtagsController,
                  hintText: 'Hashtags, comma separated',
                  minLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: parsedTags
                      .map((tag) => Chip(label: Text('#$tag')))
                      .toList(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: CustomButton(
                borderClr: Colors.transparent,
                onTap: () async {
                  await controller.addTagCollection(
                    collectionId: collection?.id,
                    title: titleController.text,
                    type: selectedType,
                    hashtags: parsedTags,
                  );
                  if (controller.hashtagCollectionError == null) Get.back();
                },
                text: 'Save',
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hintText,
    this.minLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: DynamicColor.darkGrayClr,
      ),
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: minLines == 1 ? 1 : 5,
        onChanged: onChanged,
        style: poppinsRegularStyle(
          fontSize: 14,
          context: context,
          color: theme.primaryColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: DynamicColor.lightRedClr,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

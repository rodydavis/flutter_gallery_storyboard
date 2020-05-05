// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_storyboard/flutter_storyboard.dart';
import 'package:gallery/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/l10n/gallery_localizations.dart';
import 'package:gallery/pages/backdrop.dart';
import 'package:gallery/pages/splash.dart';
import 'package:gallery/themes/gallery_theme_data.dart';

import 'demos/material/banner_demo.dart';
import 'demos/material/bottom_app_bar_demo.dart';
import 'demos/material/bottom_navigation_demo.dart';
import 'demos/material/bottom_sheet_demo.dart';
import 'demos/material/button_demo.dart';
import 'demos/material/cards_demo.dart';
import 'demos/material/chip_demo.dart';
import 'demos/material/data_table_demo.dart';
import 'demos/material/dialog_demo.dart';
import 'demos/material/grid_list_demo.dart';
import 'demos/material/list_demo.dart';
import 'demos/material/menu_demo.dart';
import 'demos/material/picker_demo.dart';
import 'demos/material/progress_indicator_demo.dart';
import 'demos/material/selection_controls_demo.dart';
import 'demos/material/sliders_demo.dart';
import 'demos/material/snackbar_demo.dart';
import 'demos/material/tabs_demo.dart';
import 'demos/material/text_field_demo.dart';
import 'demos/material/tooltip_demo.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({
    Key key,
    this.initialRoute,
    this.isTestMode = false,
  }) : super(key: key);

  final bool isTestMode;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: isTestMode,
      ),
      child: Builder(
        builder: (context) {
          return StoryBoard.material(
            // screenSize: const Size(500, 800),
            usePreferences: true,
            customScreens: [
              const BannerDemo(),
              const BottomAppBarDemo(),
              const CardsDemo(),
              const DataTableDemo(),
              const SnackbarsDemo(),
              const TextFieldDemo(),
              MultiTypesChild<BottomSheetDemoType>(
                values: BottomSheetDemoType.values,
                builder: (context, type) => BottomSheetDemo(type: type),
              ),
              MultiTypesChild<BottomNavigationDemoType>(
                values: BottomNavigationDemoType.values,
                builder: (context, type) => BottomNavigationDemo(type: type),
              ),
              MultiTypesChild<ButtonDemoType>(
                values: ButtonDemoType.values,
                builder: (context, type) => ButtonDemo(type: type),
              ),
              MultiTypesChild<ChipDemoType>(
                values: ChipDemoType.values,
                builder: (context, type) => ChipDemo(type: type),
              ),
              MultiTypesChild<DialogDemoType>(
                values: DialogDemoType.values,
                builder: (context, type) => DialogDemo(type: type),
              ),
              MultiTypesChild<GridListDemoType>(
                values: GridListDemoType.values,
                builder: (context, type) => GridListDemo(type: type),
              ),
              MultiTypesChild<ListDemoType>(
                values: ListDemoType.values,
                builder: (context, type) => ListDemo(type: type),
              ),
              MultiTypesChild<MenuDemoType>(
                values: MenuDemoType.values,
                builder: (context, type) => MenuDemo(type: type),
              ),
              MultiTypesChild<PickerDemoType>(
                values: PickerDemoType.values,
                builder: (context, type) => PickerDemo(type: type),
              ),
              MultiTypesChild<ProgressIndicatorDemoType>(
                values: ProgressIndicatorDemoType.values,
                builder: (context, type) => ProgressIndicatorDemo(type: type),
              ),
              MultiTypesChild<SelectionControlsDemoType>(
                values: SelectionControlsDemoType.values,
                builder: (context, type) => SelectionControlsDemo(type: type),
              ),
              MultiTypesChild<SlidersDemoType>(
                values: SlidersDemoType.values,
                builder: (context, type) => SlidersDemo(type: type),
              ),
              MultiTypesChild<TabsDemoType>(
                values: TabsDemoType.values,
                builder: (context, type) => TabsDemo(type: type),
              ),
            ],

            child: MaterialApp(
              title: 'Flutter Gallery',
              debugShowCheckedModeBanner: false,
              themeMode: GalleryOptions.of(context).themeMode,
              theme: GalleryThemeData.lightThemeData.copyWith(
                platform: GalleryOptions.of(context).platform,
              ),
              darkTheme: GalleryThemeData.darkThemeData.copyWith(
                platform: GalleryOptions.of(context).platform,
              ),
              localizationsDelegates: const [
                ...GalleryLocalizations.localizationsDelegates,
                LocaleNamesLocalizationsDelegate()
              ],
              initialRoute: initialRoute,
              supportedLocales: GalleryLocalizations.supportedLocales,
              locale: GalleryOptions.of(context).locale,
              localeResolutionCallback: (locale, supportedLocales) {
                deviceLocale = locale;
                return locale;
              },
              onGenerateRoute: RouteConfiguration.onGenerateRoute,
            ),
          );
        },
      ),
    );
  }
}

class MultiTypesChild<T> extends StatelessWidget {
  const MultiTypesChild({
    Key key,
    @required this.values,
    @required this.builder,
  }) : super(key: key);

  final List<T> values;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: values.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              for (final item in values) Tab(text: describeEnum(item)),
            ],
          ),
        ),
        body: TabBarView(children: [
          for (final item in values) builder(context, item),
        ]),
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ApplyTextOptions(
      child: SplashPage(
        child: Backdrop(),
      ),
    );
  }
}

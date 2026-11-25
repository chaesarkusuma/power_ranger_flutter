import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranger_archive/data/ranger_data.dart';
import 'package:ranger_archive/main.dart';
import 'package:ranger_archive/models/ranger.dart';
import 'package:ranger_archive/pages/detail_page.dart';
import 'package:ranger_archive/pages/favorites_page.dart';
import 'package:ranger_archive/utils/ranger_style.dart';
import 'package:ranger_archive/widgets/ranger_card.dart';

void main() {
  group('Minimalist Power Rangers Database', () {
    testWidgets(
      'HomePage renders minimalist header, 3-column desktop grid, search, and filters',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(const RangerArchiveApp());
        await tester.pumpAndSettle();

        final Scaffold homeScaffold = tester.widget<Scaffold>(
          find.byType(Scaffold),
        );
        expect(homeScaffold.backgroundColor, AppColors.background);

        expect(find.text('Power Rangers'), findsOneWidget);
        expect(find.text('RANGER DATABASE'), findsOneWidget);
        expect(find.text('Explore the Rangers'), findsOneWidget);
        expect(find.text('15 RANGERS'), findsOneWidget);

        // Verify 3-column layout on desktop by checking top row of cards.
        final Finder cards = find.byType(RangerCard);
        expect(cards, findsAtLeastNWidgets(3));
        final Rect card0 = tester.getRect(cards.at(0));
        final Rect card1 = tester.getRect(cards.at(1));
        final Rect card2 = tester.getRect(cards.at(2));
        expect(card0.top, closeTo(card1.top, 1));
        expect(card1.top, closeTo(card2.top, 1));
        expect(card0.right, lessThan(card1.left));
        expect(card1.right, lessThan(card2.left));

        // Search by name.
        await tester.enterText(find.byType(TextField), 'Blue Ranger');
        await tester.pumpAndSettle();
        expect(find.text('1 RANGERS'), findsOneWidget);

        // Clear search.
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();
        expect(find.text('15 RANGERS'), findsOneWidget);

        // Filter by Color dropdown.
        await tester.tap(find.byKey(const ValueKey<String>('filter-Color')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Merah').last);
        await tester.pumpAndSettle();
        expect(find.text('1 RANGERS'), findsOneWidget);

        // Reset filter.
        await tester.tap(find.text('Reset'));
        await tester.pumpAndSettle();
        expect(find.text('15 RANGERS'), findsOneWidget);

        // Filter by Element dropdown.
        await tester.tap(find.byKey(const ValueKey<String>('filter-Element')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cahaya').last);
        await tester.pumpAndSettle();
        expect(find.text('2 RANGERS'), findsOneWidget);

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Favorite toggle syncs across HomePage, FavoritesPage, and DetailPage',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(const RangerArchiveApp());
        await tester.pumpAndSettle();

        // Tap heart on the first RangerCard (Red Ranger).
        final Finder firstCardHeart = find.descendant(
          of: find.byType(RangerCard).first,
          matching: find.byIcon(Icons.favorite_border_rounded),
        );
        await tester.tap(firstCardHeart);
        await tester.pumpAndSettle();

        // Open FavoritesPage via top-right navbar heart button.
        await tester.tap(
          find.byKey(const ValueKey<String>('home-favorites-button')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(FavoritesPage), findsOneWidget);
        expect(find.text('Favorite Rangers'), findsOneWidget);
        expect(find.text('1 RANGERS'), findsOneWidget);
        expect(find.text('Red Ranger'), findsOneWidget);

        // Open DetailPage from FavoritesPage and unfavorite inside DetailPage.
        await tester.tap(find.text('Red Ranger'));
        await tester.pumpAndSettle();
        expect(find.byType(DetailPage), findsOneWidget);

        await tester.tap(
          find.byKey(const ValueKey<String>('detail-favorite-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey<String>('detail-back-button')),
        );
        await tester.pumpAndSettle();

        // FavoritesPage should now show empty state.
        expect(find.byType(FavoritesPage), findsOneWidget);
        expect(find.text('No favorite Rangers yet'), findsOneWidget);

        // Return to HomePage and verify synced state.
        await tester.tap(
          find.byKey(const ValueKey<String>('favorites-back-button')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(FavoritesPage), findsNothing);
        expect(
          find.descendant(
            of: find.byType(RangerCard).first,
            matching: find.byIcon(Icons.favorite_border_rounded),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('HomePage uses 2 columns on tablet and 1 column on mobile without overflow', (
      WidgetTester tester,
    ) async {
      // Tablet 768x1024 -> 2 columns
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const RangerArchiveApp());
      await tester.pumpAndSettle();

      final Finder tabletCards = find.byType(RangerCard);
      final Rect t0 = tester.getRect(tabletCards.at(0));
      final Rect t1 = tester.getRect(tabletCards.at(1));
      final Rect t2 = tester.getRect(tabletCards.at(2));
      expect(t0.top, closeTo(t1.top, 1));
      expect(t2.top, greaterThan(t0.bottom));
      expect(tester.takeException(), isNull);

      // Mobile 360x800 -> 1 column
      await tester.binding.setSurfaceSize(const Size(360, 800));
      await tester.pumpAndSettle();

      final Finder mobileCards = find.byType(RangerCard);
      final Rect m0 = tester.getRect(mobileCards.at(0));
      final Rect m1 = tester.getRect(mobileCards.at(1));
      expect(m1.top, greaterThan(m0.bottom));
      expect(m0.right, lessThanOrEqualTo(360));
      expect(tester.takeException(), isNull);
    });

    testWidgets('DetailPage renders responsive layouts and Deploy snackbar', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final Ranger ranger = rangerData.first;
      await tester.pumpWidget(
        MaterialApp(
          home: DetailPage(ranger: ranger, index: 1, isFavorite: false),
        ),
      );
      await tester.pumpAndSettle();

      final Rect imageRect = tester.getRect(find.byType(Image));
      final Rect infoRect = tester.getRect(find.text('Abilities'));
      expect(imageRect.right, lessThan(infoRect.left));
      expect(imageRect.width, closeTo(520, 2));

      await tester.tap(
        find.byKey(const ValueKey<String>('detail-deploy-button')),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('${ranger.codename} has been deployed to the sector.'),
        findsOneWidget,
      );

      // Mobile DetailPage
      await tester.binding.setSurfaceSize(const Size(360, 800));
      await tester.pumpAndSettle();
      final Rect mobileImage = tester.getRect(find.byType(Image));
      final Rect mobileDesc = tester.getRect(find.text('Description'));
      expect(mobileImage.bottom, lessThanOrEqualTo(mobileDesc.top));
      expect(mobileImage.right, lessThanOrEqualTo(360));
      expect(tester.takeException(), isNull);
    });
  });
}

import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Breakpoints', () {
    test('default constructor uses Bootstrap values', () {
      const Breakpoints breakpoints = Breakpoints.bootstrap;
      expect(breakpoints.xs, 0);
      expect(breakpoints.sm, 576);
      expect(breakpoints.md, 768);
      expect(breakpoints.lg, 992);
      expect(breakpoints.xl, 1200);
      expect(breakpoints.xxl, 1400);
    });

    test('custom constructor allows custom values', () {
      const breakpoints = Breakpoints(
        xs: 100,
        sm: 200,
        md: 300,
        lg: 400,
        xl: 500,
        xxl: 600,
      );
      expect(breakpoints.xs, 100);
      expect(breakpoints.sm, 200);
      expect(breakpoints.md, 300);
      expect(breakpoints.lg, 400);
      expect(breakpoints.xl, 500);
      expect(breakpoints.xxl, 600);
    });

    test('bootstrap static constant uses default values', () {
      expect(Breakpoints.bootstrap.xs, 0);
      expect(Breakpoints.bootstrap.sm, 576);
      expect(Breakpoints.bootstrap.md, 768);
      expect(Breakpoints.bootstrap.lg, 992);
      expect(Breakpoints.bootstrap.xl, 1200);
      expect(Breakpoints.bootstrap.xxl, 1400);
    });

    test('tailwind static constant uses Tailwind values', () {
      expect(Breakpoints.tailwind.xs, 0);
      expect(Breakpoints.tailwind.sm, 640);
      expect(Breakpoints.tailwind.md, 768);
      expect(Breakpoints.tailwind.lg, 1024);
      expect(Breakpoints.tailwind.xl, 1280);
      expect(Breakpoints.tailwind.xxl, 1536);
    });

    test('material static constant uses Material Design values', () {
      expect(Breakpoints.material.xs, 0);
      expect(Breakpoints.material.sm, 600);
      expect(Breakpoints.material.md, 960);
      expect(Breakpoints.material.lg, 1280);
      expect(Breakpoints.material.xl, 1920);
      expect(Breakpoints.material.xxl, 2560);
    });

    test('mobileFirst static constant uses mobile-first values', () {
      expect(Breakpoints.mobileFirst.xs, 0);
      expect(Breakpoints.mobileFirst.sm, 480);
      expect(Breakpoints.mobileFirst.md, 768);
      expect(Breakpoints.mobileFirst.lg, 1024);
      expect(Breakpoints.mobileFirst.xl, 1440);
      expect(Breakpoints.mobileFirst.xxl, 1920);
    });

    group('getBreakpoint', () {
      test('returns xs for width less than sm', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.getBreakpoint(0), Breakpoint.xs);
        expect(breakpoints.getBreakpoint(100), Breakpoint.xs);
        expect(breakpoints.getBreakpoint(575), Breakpoint.xs);
      });

      test('returns sm for width at least sm but less than md', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.getBreakpoint(576), Breakpoint.sm);
        expect(breakpoints.getBreakpoint(600), Breakpoint.sm);
        expect(breakpoints.getBreakpoint(767), Breakpoint.sm);
      });

      test('returns md for width at least md but less than lg', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.getBreakpoint(768), Breakpoint.md);
        expect(breakpoints.getBreakpoint(800), Breakpoint.md);
        expect(breakpoints.getBreakpoint(991), Breakpoint.md);
      });

      test('returns lg for width at least lg but less than xl', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.getBreakpoint(992), Breakpoint.lg);
        expect(breakpoints.getBreakpoint(1000), Breakpoint.lg);
        expect(breakpoints.getBreakpoint(1199), Breakpoint.lg);
      });

      test('returns xl for width at least xl but less than xxl', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.getBreakpoint(1200), Breakpoint.xl);
        expect(breakpoints.getBreakpoint(1300), Breakpoint.xl);
        expect(breakpoints.getBreakpoint(1399), Breakpoint.xl);
      });

      test('returns xxl for width at least xxl', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.getBreakpoint(1400), Breakpoint.xxl);
        expect(breakpoints.getBreakpoint(1500), Breakpoint.xxl);
        expect(breakpoints.getBreakpoint(2000), Breakpoint.xxl);
      });
    });

    group('isAtLeast', () {
      test('returns true when width is at least breakpoint', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isAtLeast(Breakpoint.sm, 576), true);
        expect(breakpoints.isAtLeast(Breakpoint.sm, 600), true);
        expect(breakpoints.isAtLeast(Breakpoint.md, 800), true);
        expect(breakpoints.isAtLeast(Breakpoint.lg, 1000), true);
      });

      test('returns false when width is less than breakpoint', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isAtLeast(Breakpoint.sm, 575), false);
        expect(breakpoints.isAtLeast(Breakpoint.md, 600), false);
        expect(breakpoints.isAtLeast(Breakpoint.lg, 800), false);
      });
    });

    group('isLessThan', () {
      test('returns true when width is less than breakpoint', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isLessThan(Breakpoint.sm, 575), true);
        expect(breakpoints.isLessThan(Breakpoint.md, 600), true);
        expect(breakpoints.isLessThan(Breakpoint.lg, 800), true);
      });

      test('returns false when width is at least breakpoint', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isLessThan(Breakpoint.sm, 576), false);
        expect(breakpoints.isLessThan(Breakpoint.sm, 600), false);
        expect(breakpoints.isLessThan(Breakpoint.md, 800), false);
      });
    });

    group('isBetween', () {
      test('returns true when width is between breakpoints', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isBetween(Breakpoint.sm, Breakpoint.md, 600), true);
        expect(breakpoints.isBetween(Breakpoint.md, Breakpoint.lg, 800), true);
        expect(breakpoints.isBetween(Breakpoint.lg, Breakpoint.xl, 1000), true);
      });

      test('returns false when width is not between breakpoints', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isBetween(Breakpoint.sm, Breakpoint.md, 500), false);
        expect(breakpoints.isBetween(Breakpoint.sm, Breakpoint.md, 800), false);
      });

      test('returns true for inclusive min boundary', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isBetween(Breakpoint.sm, Breakpoint.md, 576), true);
      });

      test('returns false for exclusive max boundary', () {
        const Breakpoints breakpoints = Breakpoints.bootstrap;
        expect(breakpoints.isBetween(Breakpoint.sm, Breakpoint.md, 768), false);
      });
    });
  });

  group('Breakpoint enum', () {
    test('has correct values', () {
      expect(Breakpoint.values.length, 6);
      expect(Breakpoint.values, [
        Breakpoint.xs,
        Breakpoint.sm,
        Breakpoint.md,
        Breakpoint.lg,
        Breakpoint.xl,
        Breakpoint.xxl,
      ]);
    });
  });

  group('BreakpointExtension', () {
    test('isAtLeast returns true for larger or equal breakpoints', () {
      expect(Breakpoint.md.isAtLeast(Breakpoint.xs), true);
      expect(Breakpoint.md.isAtLeast(Breakpoint.sm), true);
      expect(Breakpoint.md.isAtLeast(Breakpoint.md), true);
      expect(Breakpoint.md.isAtLeast(Breakpoint.lg), false);
    });

    test('isSmallerThan returns true for smaller breakpoints', () {
      expect(Breakpoint.sm.isSmallerThan(Breakpoint.md), true);
      expect(Breakpoint.sm.isSmallerThan(Breakpoint.lg), true);
      expect(Breakpoint.sm.isSmallerThan(Breakpoint.sm), false);
      expect(Breakpoint.sm.isSmallerThan(Breakpoint.xs), false);
    });

    test('next returns next larger breakpoint', () {
      expect(Breakpoint.xs.next, Breakpoint.sm);
      expect(Breakpoint.sm.next, Breakpoint.md);
      expect(Breakpoint.md.next, Breakpoint.lg);
      expect(Breakpoint.lg.next, Breakpoint.xl);
      expect(Breakpoint.xl.next, Breakpoint.xxl);
      expect(Breakpoint.xxl.next, null);
    });

    test('previous returns previous smaller breakpoint', () {
      expect(Breakpoint.xxl.previous, Breakpoint.xl);
      expect(Breakpoint.xl.previous, Breakpoint.lg);
      expect(Breakpoint.lg.previous, Breakpoint.md);
      expect(Breakpoint.md.previous, Breakpoint.sm);
      expect(Breakpoint.sm.previous, Breakpoint.xs);
      expect(Breakpoint.xs.previous, null);
    });
  });
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GoRoute';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSubtitle =>
      'Professional account · session stored securely on device';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get signOut => 'Sign out';

  @override
  String get mfaTitle => 'Two-factor code';

  @override
  String get mfaHeadline => 'Enter authenticator code';

  @override
  String get mfaBody =>
      'Use the 6-digit TOTP from your authenticator app, or a backup code.';

  @override
  String get code => 'Code';

  @override
  String get verify => 'Verify';

  @override
  String get verifying => 'Verifying…';

  @override
  String get roadmapTitle => 'Roadmap';

  @override
  String get progress => 'Progress';

  @override
  String get nodes => 'Nodes';

  @override
  String get etaWeeks => 'ETA (weeks)';

  @override
  String get nextFocus => 'Next focus';

  @override
  String get yourTrack => 'Your track';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String get unexpectedError => 'Unexpected error';

  @override
  String get connectionError =>
      'Could not reach the server. Check Wi‑Fi and that the API is running.';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyBody =>
      'When there is content for this section, it will show up here.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get brandTagline => 'Plan your next career move with clarity.';

  @override
  String get navHome => 'Home';

  @override
  String get navRoadmap => 'Track';

  @override
  String get navWeekly => 'Week';

  @override
  String get navJobs => 'Jobs';

  @override
  String get navMore => 'More';

  @override
  String get homeSubtitle => 'Your next career step, at a glance.';

  @override
  String get homeNoNext => 'No recommended node yet — open your track.';

  @override
  String get homeOpenNode => 'Open next milestone';

  @override
  String get homeCtaRoadmap => 'Open track';

  @override
  String get homeCtaWeekly => 'Weekly plan';

  @override
  String get roadmapEmptyTitle => 'No nodes on your track';

  @override
  String get roadmapEmptyBody =>
      'Complete onboarding on the web if your roadmap is empty.';

  @override
  String get nodeDetailTitle => 'Milestone';

  @override
  String get nodeStateCompleted => 'Completed';

  @override
  String get nodeStateInProgress => 'In progress';

  @override
  String get nodeStateAvailable => 'Available';

  @override
  String get nodeStateRecommended => 'Recommended';

  @override
  String get nodeStateLocked => 'Locked';

  @override
  String get nodeStateUnknown => 'Unknown';

  @override
  String get nodeLockedHint =>
      'This milestone is locked. Finish the prerequisites first.';

  @override
  String get prerequisites => 'Prerequisites';

  @override
  String get startNode => 'Start';

  @override
  String get completeNode => 'Mark complete';

  @override
  String get working => 'Working…';

  @override
  String get actionSuccess => 'Updated';

  @override
  String get nodeNoAction =>
      'No action available for this milestone right now.';

  @override
  String get premiumRequired => 'Weekly plan requires an active subscription.';

  @override
  String get premiumRequiredTitle => 'Premium feature';

  @override
  String get weeklyEmptyTitle => 'No weekly plan yet';

  @override
  String get weeklyEmptyBody =>
      'Recalculate to generate this week\'s focus and tasks.';

  @override
  String get completeTask => 'Done';

  @override
  String get skipWeek => 'Skip this week';

  @override
  String get recalculateWeek => 'Recalculate';

  @override
  String get jobsEmptyTitle => 'No matching jobs';

  @override
  String get jobsEmptyBody =>
      'When published roles match your profile, they will show up here.';

  @override
  String get jobDetailTitle => 'Job';

  @override
  String get jobSkills => 'Required skills';

  @override
  String get whyThisMatch => 'Why this match %?';

  @override
  String get closingSkills => 'Skills to close the gap';

  @override
  String get applyJob => 'Apply';

  @override
  String get applySuccess => 'Application submitted';

  @override
  String get jobApplyNotEligible => 'You need 100% match to apply to this job.';

  @override
  String get mentorTitle => 'Mentor';

  @override
  String get mentorHint =>
      'Ask about your next career step, skills to learn, or what to focus on.';

  @override
  String get mentorPlaceholder => 'Ask the mentor…';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyBody =>
      'Updates about your track and offers will show up here.';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSection => 'Profile';

  @override
  String get nameReadOnlyHint =>
      'Legal name is managed in billing / web settings.';

  @override
  String get headlineLabel => 'Headline';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get aiSection => 'AI mentor';

  @override
  String get mentorModeLabel => 'Mentor mode';

  @override
  String get mentorModeOff => 'Off';

  @override
  String get mentorModeManaged => 'Managed (GoRoute)';

  @override
  String get mentorModeByok => 'BYOK';

  @override
  String get lgpdConsentLabel =>
      'I consent to AI processing of my career data (LGPD).';

  @override
  String get byokWebHint =>
      'Add your API key on the web settings screen; mobile only switches mode.';

  @override
  String get saveAi => 'Save AI settings';

  @override
  String get privacySection => 'Privacy';

  @override
  String get exportPrivacy => 'Export my data';

  @override
  String get exportCopied => 'Export JSON copied to clipboard';

  @override
  String get eraseSection => 'Delete account';

  @override
  String get eraseBody =>
      'This permanently erases your account. Type DELETE to confirm.';

  @override
  String get eraseConfirmLabel => 'Type DELETE';

  @override
  String get eraseConfirmHint => 'Type DELETE exactly to confirm.';

  @override
  String get eraseAccount => 'Erase account';

  @override
  String get jobsSearchHint => 'Search by title or company';

  @override
  String get homeCtaJobs => 'Browse jobs';

  @override
  String get homeCtaMentor => 'Ask the mentor';

  @override
  String get askMentor => 'Ask mentor';

  @override
  String get clearChat => 'Clear chat';

  @override
  String get openInTrack => 'Open in track';

  @override
  String get viewPlans => 'View plans';

  @override
  String get premiumCtaBody => 'Upgrade on the web to unlock your weekly plan.';

  @override
  String get connectionHelpTitle => 'Can\'t connect?';

  @override
  String get connectionHelpBody =>
      'Use the same Wi‑Fi as your computer and a debug APK built with your PC LAN IP (not the production release).';

  @override
  String get connectionTip =>
      'Tip: same Wi‑Fi as the PC · debug APK with LAN IP · API must be running.';

  @override
  String mentorPrefillNext(String label) {
    return 'What should I focus on next for $label?';
  }

  @override
  String mentorPrefillNode(String label) {
    return 'How do I progress on $label?';
  }

  @override
  String mentorPrefillJob(String label) {
    return 'How do I close the skill gap for $label?';
  }

  @override
  String get aboutTitle => 'About GoRoute';

  @override
  String get asoTitle => 'GoRoute: Career Plan';

  @override
  String get asoSubtitle => 'Track, skills and matched jobs';

  @override
  String get asoPromise =>
      'See your next concrete career step — track, week and jobs with match — without guessing what to learn alone.';

  @override
  String get connectionHelpShort => 'Wi‑Fi, debug APK and API tips';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeSystem => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'Auto';

  @override
  String get languagePt => 'Português';

  @override
  String get languageEn => 'English';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get dashboardOverview => 'Career dashboard';

  @override
  String get dashboardShortcuts => 'Shortcuts';

  @override
  String get dashboardNodes => 'Milestones';

  @override
  String get sessionExpired =>
      'Your session expired. Sign in again to continue.';

  @override
  String get signInAgain => 'Sign in again';

  @override
  String get weeklyHeroTitle => 'This week';

  @override
  String weeklyTasksDone(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get weeklyTip =>
      'Tip: finish the study task first, then the practice project.';

  @override
  String get weeklyFocusSection => 'Week focus';

  @override
  String get weeklyChecklist => 'Checklist';

  @override
  String get weeklyActions => 'Week actions';

  @override
  String get taskTypeStudy => 'Study';

  @override
  String get taskTypeProject => 'Project';

  @override
  String get taskTypePractice => 'Practice';

  @override
  String get taskTypeOther => 'Task';

  @override
  String get aboutWhatTitle => 'What GoRoute does';

  @override
  String get aboutWhatBody =>
      'Turns a career goal into a track with milestones, a weekly plan you can finish, matched jobs, and a mentor for the next decision.';

  @override
  String get aboutHowTitle => 'How to use the app';

  @override
  String get aboutHow1 => 'Home — see progress and your next focus.';

  @override
  String get aboutHow2 => 'Track — open milestones, start and complete them.';

  @override
  String get aboutHow3 => 'Week — complete the checklist for this week.';

  @override
  String get aboutHow4 => 'Jobs — browse matches and close skill gaps.';

  @override
  String get aboutHow5 => 'More — mentor, notifications, theme and language.';

  @override
  String get aboutPrivacyTitle => 'Privacy';

  @override
  String get aboutPrivacyBody =>
      'Account data stays under your session. Export or erase from Settings. AI mentor modes respect LGPD consent.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String nodeHours(int logged, int estimated) {
    return '$logged / $estimated h logged';
  }

  @override
  String get nodeNotes => 'Notes';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create account';

  @override
  String get signUpTitle => 'Create your account';

  @override
  String get signUpSubtitle => 'Take your career roadmap with you.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get acceptTerms =>
      'I\'ve read and accept the Terms of Use and the Privacy Policy.';

  @override
  String get signingUp => 'Creating account…';

  @override
  String get errorWeakPassword => 'Password must be at least 8 characters.';

  @override
  String get errorEmailInUse => 'This email is already registered.';

  @override
  String get errorTermsRequired => 'You need to accept the terms to continue.';

  @override
  String get passwordMismatch => 'Passwords don\'t match.';

  @override
  String get accountCreatedSuccess => 'Account created! Sign in to continue.';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get aiManagedNotEntitled =>
      'AI Mentor (managed) requires the Weekly plan subscription.';

  @override
  String get mentorScopeInTrack => 'On your track';

  @override
  String get mentorScopeSoftSkills => 'Soft skill';

  @override
  String get mentorScopeOutOfScope => 'Outside your track';

  @override
  String get skillsTitle => 'Skills';

  @override
  String get skillTrackTitle => 'Technical track';

  @override
  String get learnByDoing => 'Learn by Doing';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';
}

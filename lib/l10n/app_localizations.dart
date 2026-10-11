import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GoRoute'**
  String get appTitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Professional account · session stored securely on device'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @mfaTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-factor code'**
  String get mfaTitle;

  /// No description provided for @mfaHeadline.
  ///
  /// In en, this message translates to:
  /// **'Enter authenticator code'**
  String get mfaHeadline;

  /// No description provided for @mfaBody.
  ///
  /// In en, this message translates to:
  /// **'Use the 6-digit TOTP from your authenticator app, or a backup code.'**
  String get mfaBody;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get verifying;

  /// No description provided for @roadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Roadmap'**
  String get roadmapTitle;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @nodes.
  ///
  /// In en, this message translates to:
  /// **'Nodes'**
  String get nodes;

  /// No description provided for @etaWeeks.
  ///
  /// In en, this message translates to:
  /// **'ETA (weeks)'**
  String get etaWeeks;

  /// No description provided for @nextFocus.
  ///
  /// In en, this message translates to:
  /// **'Next focus'**
  String get nextFocus;

  /// No description provided for @yourTrack.
  ///
  /// In en, this message translates to:
  /// **'Your track'**
  String get yourTrack;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpectedError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check Wi‑Fi and that the API is running.'**
  String get connectionError;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'When there is content for this section, it will show up here.'**
  String get emptyBody;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan your next career move with clarity.'**
  String get brandTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get navRoadmap;

  /// No description provided for @navWeekly.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get navWeekly;

  /// No description provided for @navJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your next career step, at a glance.'**
  String get homeSubtitle;

  /// No description provided for @homeNoNext.
  ///
  /// In en, this message translates to:
  /// **'No recommended node yet — open your track.'**
  String get homeNoNext;

  /// No description provided for @homeOpenNode.
  ///
  /// In en, this message translates to:
  /// **'Open next milestone'**
  String get homeOpenNode;

  /// No description provided for @homeCtaRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Open track'**
  String get homeCtaRoadmap;

  /// No description provided for @homeCtaWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get homeCtaWeekly;

  /// No description provided for @roadmapEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No nodes on your track'**
  String get roadmapEmptyTitle;

  /// No description provided for @roadmapEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete onboarding on the web if your roadmap is empty.'**
  String get roadmapEmptyBody;

  /// No description provided for @nodeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get nodeDetailTitle;

  /// No description provided for @nodeStateCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get nodeStateCompleted;

  /// No description provided for @nodeStateInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get nodeStateInProgress;

  /// No description provided for @nodeStateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get nodeStateAvailable;

  /// No description provided for @nodeStateRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get nodeStateRecommended;

  /// No description provided for @nodeStateLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get nodeStateLocked;

  /// No description provided for @nodeStateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get nodeStateUnknown;

  /// No description provided for @nodeLockedHint.
  ///
  /// In en, this message translates to:
  /// **'This milestone is locked. Finish the prerequisites first.'**
  String get nodeLockedHint;

  /// No description provided for @prerequisites.
  ///
  /// In en, this message translates to:
  /// **'Prerequisites'**
  String get prerequisites;

  /// No description provided for @startNode.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startNode;

  /// No description provided for @completeNode.
  ///
  /// In en, this message translates to:
  /// **'Mark complete'**
  String get completeNode;

  /// No description provided for @working.
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get working;

  /// No description provided for @actionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get actionSuccess;

  /// No description provided for @nodeNoAction.
  ///
  /// In en, this message translates to:
  /// **'No action available for this milestone right now.'**
  String get nodeNoAction;

  /// No description provided for @premiumRequired.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan requires an active subscription.'**
  String get premiumRequired;

  /// No description provided for @premiumRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium feature'**
  String get premiumRequiredTitle;

  /// No description provided for @weeklyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No weekly plan yet'**
  String get weeklyEmptyTitle;

  /// No description provided for @weeklyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Recalculate to generate this week\'s focus and tasks.'**
  String get weeklyEmptyBody;

  /// No description provided for @completeTask.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get completeTask;

  /// No description provided for @skipWeek.
  ///
  /// In en, this message translates to:
  /// **'Skip this week'**
  String get skipWeek;

  /// No description provided for @recalculateWeek.
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get recalculateWeek;

  /// No description provided for @jobsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching jobs'**
  String get jobsEmptyTitle;

  /// No description provided for @jobsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When published roles match your profile, they will show up here.'**
  String get jobsEmptyBody;

  /// No description provided for @jobDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get jobDetailTitle;

  /// No description provided for @jobSkills.
  ///
  /// In en, this message translates to:
  /// **'Required skills'**
  String get jobSkills;

  /// No description provided for @whyThisMatch.
  ///
  /// In en, this message translates to:
  /// **'Why this match %?'**
  String get whyThisMatch;

  /// No description provided for @closingSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills to close the gap'**
  String get closingSkills;

  /// No description provided for @applyJob.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyJob;

  /// No description provided for @applySuccess.
  ///
  /// In en, this message translates to:
  /// **'Application submitted'**
  String get applySuccess;

  /// No description provided for @jobApplyNotEligible.
  ///
  /// In en, this message translates to:
  /// **'You need 100% match to apply to this job.'**
  String get jobApplyNotEligible;

  /// No description provided for @mentorTitle.
  ///
  /// In en, this message translates to:
  /// **'Mentor'**
  String get mentorTitle;

  /// No description provided for @mentorHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about your next career step, skills to learn, or what to focus on.'**
  String get mentorHint;

  /// No description provided for @mentorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ask the mentor…'**
  String get mentorPlaceholder;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Updates about your track and offers will show up here.'**
  String get notificationsEmptyBody;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @nameReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Legal name is managed in billing / web settings.'**
  String get nameReadOnlyHint;

  /// No description provided for @headlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get headlineLabel;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @aiSection.
  ///
  /// In en, this message translates to:
  /// **'AI mentor'**
  String get aiSection;

  /// No description provided for @mentorModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mentor mode'**
  String get mentorModeLabel;

  /// No description provided for @mentorModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get mentorModeOff;

  /// No description provided for @mentorModeManaged.
  ///
  /// In en, this message translates to:
  /// **'Managed (GoRoute)'**
  String get mentorModeManaged;

  /// No description provided for @mentorModeByok.
  ///
  /// In en, this message translates to:
  /// **'BYOK'**
  String get mentorModeByok;

  /// No description provided for @lgpdConsentLabel.
  ///
  /// In en, this message translates to:
  /// **'I consent to AI processing of my career data (LGPD).'**
  String get lgpdConsentLabel;

  /// No description provided for @byokWebHint.
  ///
  /// In en, this message translates to:
  /// **'Add your API key on the web settings screen; mobile only switches mode.'**
  String get byokWebHint;

  /// No description provided for @saveAi.
  ///
  /// In en, this message translates to:
  /// **'Save AI settings'**
  String get saveAi;

  /// No description provided for @privacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySection;

  /// No description provided for @exportPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get exportPrivacy;

  /// No description provided for @exportCopied.
  ///
  /// In en, this message translates to:
  /// **'Export JSON copied to clipboard'**
  String get exportCopied;

  /// No description provided for @eraseSection.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get eraseSection;

  /// No description provided for @eraseBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently erases your account. Type DELETE to confirm.'**
  String get eraseBody;

  /// No description provided for @eraseConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE'**
  String get eraseConfirmLabel;

  /// No description provided for @eraseConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE exactly to confirm.'**
  String get eraseConfirmHint;

  /// No description provided for @eraseAccount.
  ///
  /// In en, this message translates to:
  /// **'Erase account'**
  String get eraseAccount;

  /// No description provided for @jobsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or company'**
  String get jobsSearchHint;

  /// No description provided for @homeCtaJobs.
  ///
  /// In en, this message translates to:
  /// **'Browse jobs'**
  String get homeCtaJobs;

  /// No description provided for @homeCtaMentor.
  ///
  /// In en, this message translates to:
  /// **'Ask the mentor'**
  String get homeCtaMentor;

  /// No description provided for @askMentor.
  ///
  /// In en, this message translates to:
  /// **'Ask mentor'**
  String get askMentor;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// No description provided for @openInTrack.
  ///
  /// In en, this message translates to:
  /// **'Open in track'**
  String get openInTrack;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View plans'**
  String get viewPlans;

  /// No description provided for @premiumCtaBody.
  ///
  /// In en, this message translates to:
  /// **'Upgrade on the web to unlock your weekly plan.'**
  String get premiumCtaBody;

  /// No description provided for @connectionHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect?'**
  String get connectionHelpTitle;

  /// No description provided for @connectionHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Use the same Wi‑Fi as your computer and a debug APK built with your PC LAN IP (not the production release).'**
  String get connectionHelpBody;

  /// No description provided for @connectionTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: same Wi‑Fi as the PC · debug APK with LAN IP · API must be running.'**
  String get connectionTip;

  /// No description provided for @mentorPrefillNext.
  ///
  /// In en, this message translates to:
  /// **'What should I focus on next for {label}?'**
  String mentorPrefillNext(String label);

  /// No description provided for @mentorPrefillNode.
  ///
  /// In en, this message translates to:
  /// **'How do I progress on {label}?'**
  String mentorPrefillNode(String label);

  /// No description provided for @mentorPrefillJob.
  ///
  /// In en, this message translates to:
  /// **'How do I close the skill gap for {label}?'**
  String mentorPrefillJob(String label);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About GoRoute'**
  String get aboutTitle;

  /// No description provided for @asoTitle.
  ///
  /// In en, this message translates to:
  /// **'GoRoute: Career Plan'**
  String get asoTitle;

  /// No description provided for @asoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track, skills and matched jobs'**
  String get asoSubtitle;

  /// No description provided for @asoPromise.
  ///
  /// In en, this message translates to:
  /// **'See your next concrete career step — track, week and jobs with match — without guessing what to learn alone.'**
  String get asoPromise;

  /// No description provided for @connectionHelpShort.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi, debug APK and API tips'**
  String get connectionHelpShort;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get languageSystem;

  /// No description provided for @languagePt.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePt;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Career dashboard'**
  String get dashboardOverview;

  /// No description provided for @dashboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get dashboardShortcuts;

  /// No description provided for @dashboardNodes.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get dashboardNodes;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again to continue.'**
  String get sessionExpired;

  /// No description provided for @signInAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get signInAgain;

  /// No description provided for @weeklyHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weeklyHeroTitle;

  /// No description provided for @weeklyTasksDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String weeklyTasksDone(int done, int total);

  /// No description provided for @weeklyTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: finish the study task first, then the practice project.'**
  String get weeklyTip;

  /// No description provided for @weeklyFocusSection.
  ///
  /// In en, this message translates to:
  /// **'Week focus'**
  String get weeklyFocusSection;

  /// No description provided for @weeklyChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get weeklyChecklist;

  /// No description provided for @weeklyActions.
  ///
  /// In en, this message translates to:
  /// **'Week actions'**
  String get weeklyActions;

  /// No description provided for @taskTypeStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get taskTypeStudy;

  /// No description provided for @taskTypeProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get taskTypeProject;

  /// No description provided for @taskTypePractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get taskTypePractice;

  /// No description provided for @taskTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskTypeOther;

  /// No description provided for @aboutWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What GoRoute does'**
  String get aboutWhatTitle;

  /// No description provided for @aboutWhatBody.
  ///
  /// In en, this message translates to:
  /// **'Turns a career goal into a track with milestones, a weekly plan you can finish, matched jobs, and a mentor for the next decision.'**
  String get aboutWhatBody;

  /// No description provided for @aboutHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use the app'**
  String get aboutHowTitle;

  /// No description provided for @aboutHow1.
  ///
  /// In en, this message translates to:
  /// **'Home — see progress and your next focus.'**
  String get aboutHow1;

  /// No description provided for @aboutHow2.
  ///
  /// In en, this message translates to:
  /// **'Track — open milestones, start and complete them.'**
  String get aboutHow2;

  /// No description provided for @aboutHow3.
  ///
  /// In en, this message translates to:
  /// **'Week — complete the checklist for this week.'**
  String get aboutHow3;

  /// No description provided for @aboutHow4.
  ///
  /// In en, this message translates to:
  /// **'Jobs — browse matches and close skill gaps.'**
  String get aboutHow4;

  /// No description provided for @aboutHow5.
  ///
  /// In en, this message translates to:
  /// **'More — mentor, notifications, theme and language.'**
  String get aboutHow5;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Account data stays under your session. Export or erase from Settings. AI mentor modes respect LGPD consent.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @nodeHours.
  ///
  /// In en, this message translates to:
  /// **'{logged} / {estimated} h logged'**
  String nodeHours(int logged, int estimated);

  /// No description provided for @nodeNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get nodeNotes;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take your career roadmap with you.'**
  String get signUpSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I\'ve read and accept the Terms of Use and the Privacy Policy.'**
  String get acceptTerms;

  /// No description provided for @signingUp.
  ///
  /// In en, this message translates to:
  /// **'Creating account…'**
  String get signingUp;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailInUse;

  /// No description provided for @errorTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You need to accept the terms to continue.'**
  String get errorTermsRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get passwordMismatch;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created! Sign in to continue.'**
  String get accountCreatedSuccess;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToLogin;

  /// No description provided for @aiManagedNotEntitled.
  ///
  /// In en, this message translates to:
  /// **'AI Mentor (managed) requires the Weekly plan subscription.'**
  String get aiManagedNotEntitled;

  /// No description provided for @mentorScopeInTrack.
  ///
  /// In en, this message translates to:
  /// **'On your track'**
  String get mentorScopeInTrack;

  /// No description provided for @mentorScopeSoftSkills.
  ///
  /// In en, this message translates to:
  /// **'Soft skill'**
  String get mentorScopeSoftSkills;

  /// No description provided for @mentorScopeOutOfScope.
  ///
  /// In en, this message translates to:
  /// **'Outside your track'**
  String get mentorScopeOutOfScope;

  /// No description provided for @skillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsTitle;

  /// No description provided for @skillTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical track'**
  String get skillTrackTitle;

  /// No description provided for @learnByDoing.
  ///
  /// In en, this message translates to:
  /// **'Learn by Doing'**
  String get learnByDoing;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/mentor/mentor_chat_store.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class MentorPage extends ConsumerStatefulWidget {
  const MentorPage({super.key, this.extra});

  final MentorRouteExtra? extra;

  @override
  ConsumerState<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends ConsumerState<MentorPage> {
  final _input = TextEditingController();
  final _messages = <MentorChatMessage>[];
  bool _busy = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final prefill = widget.extra?.prefillQuestion;
    if (prefill != null && prefill.isNotEmpty) {
      _input.text = prefill;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final stored = ref.read(mentorChatStoreProvider).load();
    if (stored.isNotEmpty) {
      setState(() => _messages.addAll(stored));
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _persist() async {
    await ref.read(mentorChatStoreProvider).save(_messages);
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final question = _input.text.trim();
    if (question.isEmpty || _busy) return;

    setState(() {
      _busy = true;
      _messages.add(MentorChatMessage(role: 'user', text: question));
      _input.clear();
    });
    await _persist();

    try {
      final answer =
          await ref.read(mentorRepositoryProvider).analyze(question: question);
      if (!mounted) return;
      setState(() {
        _messages.add(
          MentorChatMessage(
            role: 'mentor',
            text: answer.displayText.isEmpty
                ? answer.summary
                : answer.displayText,
            scope: answer.scope,
          ),
        );
      });
      await _persist();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          MentorChatMessage(
            role: 'mentor',
            text: mapErrorMessage(e, l10n),
          ),
        );
      });
      await _persist();
      if (mounted && isSessionFailure(e)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.sessionExpired),
            action: SnackBarAction(
              label: l10n.signInAgain,
              onPressed: () => context.go('/login'),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final contextLabel = widget.extra?.contextLabel;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mentorTitle),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              tooltip: l10n.clearChat,
              onPressed: _busy
                  ? null
                  : () async {
                      setState(() => _messages.clear());
                      await ref.read(mentorChatStoreProvider).clear();
                    },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Column(
        children: [
          if (contextLabel != null && contextLabel.isNotEmpty)
            Material(
              color: scheme.primaryContainer,
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.flag_outlined),
                title: Text(contextLabel),
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.mentorHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final m = _messages[index];
                      final isUser = m.role == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width * 0.85,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? scheme.primaryContainer
                                : scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (m.scope != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    m.scope!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: scheme.primary),
                                  ),
                                ),
                              Text(m.text),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      enabled: !_busy,
                      decoration: InputDecoration(
                        hintText: l10n.mentorPlaceholder,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _busy ? null : _send,
                    icon: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

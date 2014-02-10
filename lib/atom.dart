library restlib.atom;

import "package:restlib_common/collections.dart";
import "package:restlib_common/collections.immutable.dart";
import "package:restlib_common/objects.dart";
import "package:restlib_common/preconditions.dart";

import "package:restlib_core/data.dart";
import "package:restlib_core/net.dart";

import "atom.link_relationships.dart";

part "src/atom/forwarding.dart";
part "src/atom/implementation.dart";

abstract class AtomEntry<T> {
  factory AtomEntry(
      final IRI id,
      final String title,
      final DateTime updated, {
        final Iterable<AtomPerson> authors: Persistent.EMPTY_SEQUENCE,
        final Iterable <AtomCategory> categories: Persistent.EMPTY_SEQUENCE,
        final T content,
        final Iterable<AtomPerson> contributors: Persistent.EMPTY_SEQUENCE,
        final Iterable<AtomLink> links: Persistent.EMPTY_SEQUENCE,
        final DateTime published,
        final String rights,
        final AtomFeed source,
        final String summary}) => 
            new _AtomEntry(
                authors, categories, new Option(content),
                contributors, checkNotNull(id), links,
                new Option(published), new Option(rights), new Option(source),
                new Option(summary), checkNotNull(title), checkNotNull(updated));
  
  Iterable<AtomPerson> get authors;
  Iterable <AtomCategory> get categories;
  Option<T> get content;
  Iterable<AtomPerson> get contributors;
  IRI get id;
  Iterable<AtomLink> get links;
  Option<DateTime> get published;
  Option<String> get rights;
  Option<AtomFeed> get source;
  Option<String> get summary;
  String get title;
  DateTime get updated;
}

abstract class AtomFeed<T extends AtomEntry> {
  Iterable<AtomPerson> get authors;
  Iterable<AtomCategory> get categories;
  Iterable<AtomPerson> get contributors;
  Iterable<T> get entries;
  Option<AtomGenerator> get generator;
  Option<IRI> get icon;
  IRI get id;
  Iterable<AtomLink> get links;
  Option<IRI> get logo;
  Option<String> get rights;
  Option<String> get subtitle;
  String get title;
  DateTime get updated;
}

abstract class AtomGenerator {
  String get content;
  Option<IRI> get uri;
  Option<String> get version;
}

abstract class AtomPerson {
  Option/*<EmailAddress>*/ get email;
  String get name;
  Option<IRI> get uri;
}

abstract class AtomCategory {
  factory AtomCategory(
      {final String label,
        final IRI scheme,
        final String term}) =>
            new _AtomCategory(new Option(label), new Option(scheme), checkNotNull(term));
          
  Option<String> get label;
  Option<IRI> get scheme;
  String get term;
}

abstract class AtomLink {
  static ImmutableSequence<AtomLink> alternativeLinks(final IRI href, Iterable<Pair<String, MediaRange>> alternatives) =>
      alternatives.fold(Persistent.EMPTY_SEQUENCE, (final ImmutableSequence sequence, Pair<String, MediaRange> pair) =>
          // FIXME: User IRI_ but its crashing right now.
          sequence.add(new AtomLink(URI_.parseValue("$href.${pair.fst}"), rel: ALTERNATE, type: pair.snd)));   
  
  factory AtomLink(final IRI href, {
        final Language language,
        final int length,
        final String rel,
        final String title,
        final MediaRange type}) =>
      new _AtomLink(
          href, new Option(language), new Option(length),
          new Option(rel), new Option(title), new Option(type));
  
  factory AtomLink.edit(final IRI href) =>
      new AtomLink(href, rel: EDIT);
      
  factory AtomLink.self(final IRI href) =>
      new AtomLink(href, rel: SELF);
  
  IRI get href;
  Option<Language> get hrefLanguage;
  Option<int> get length;
  Option<String> get rel;
  Option<String> get title;
  Option<MediaRange> get type;
}
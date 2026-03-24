// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _projectIdMeta =
      VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(2));
  static const VerificationMeta _dueDateMeta =
      VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reminderMinutesMeta =
      VerificationMeta('reminderMinutes');
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
      'reminder_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _doneMeta = VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
      'done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("done" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _sortOrderMeta =
      VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _createdAtMeta =
      VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        notes,
        projectId,
        priority,
        dueDate,
        reminderMinutes,
        done,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
          _reminderMinutesMeta,
          reminderMinutes.isAcceptableOrUnknown(
              data['reminder_minutes']!, _reminderMinutesMeta));
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      reminderMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_minutes']),
      done: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}done'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String title;
  final String? notes;
  final String? projectId;

  /// Priority: 1 = P1 (highest) … 4 = P4 (lowest)
  final int priority;
  final DateTime? dueDate;

  /// Reminder offset in minutes (e.g. 15, 30, 60, 1440). Null = no reminder.
  final int? reminderMinutes;
  final bool done;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  Task(
      {required this.id,
      required this.title,
      this.notes,
      this.projectId,
      required this.priority,
      this.dueDate,
      this.reminderMinutes,
      required this.done,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || reminderMinutes != null) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes);
    }
    map['done'] = Variable<bool>(done);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      priority: Value(priority),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      reminderMinutes: reminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutes),
      done: Value(done),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      priority: serializer.fromJson<int>(json['priority']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      reminderMinutes: serializer.fromJson<int?>(json['reminderMinutes']),
      done: serializer.fromJson<bool>(json['done']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'projectId': serializer.toJson<String?>(projectId),
      'priority': serializer.toJson<int>(priority),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'reminderMinutes': serializer.toJson<int?>(reminderMinutes),
      'done': serializer.toJson<bool>(done),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith(
          {String? id,
          String? title,
          Value<String?> notes = const Value.absent(),
          Value<String?> projectId = const Value.absent(),
          int? priority,
          Value<DateTime?> dueDate = const Value.absent(),
          Value<int?> reminderMinutes = const Value.absent(),
          bool? done,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        notes: notes.present ? notes.value : this.notes,
        projectId: projectId.present ? projectId.value : this.projectId,
        priority: priority ?? this.priority,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        reminderMinutes: reminderMinutes.present
            ? reminderMinutes.value
            : this.reminderMinutes,
        done: done ?? this.done,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      done: data.done.present ? data.done.value : this.done,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('projectId: $projectId, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, notes, projectId, priority,
      dueDate, reminderMinutes, done, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.projectId == this.projectId &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.reminderMinutes == this.reminderMinutes &&
          other.done == this.done &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String?> projectId;
  final Value<int> priority;
  final Value<DateTime?> dueDate;
  final Value<int?> reminderMinutes;
  final Value<bool> done;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.projectId = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.notes = const Value.absent(),
    this.projectId = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? projectId,
    Expression<int>? priority,
    Expression<DateTime>? dueDate,
    Expression<int>? reminderMinutes,
    Expression<bool>? done,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (projectId != null) 'project_id': projectId,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (done != null) 'done': done,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? notes,
      Value<String?>? projectId,
      Value<int>? priority,
      Value<DateTime?>? dueDate,
      Value<int?>? reminderMinutes,
      Value<bool>? done,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      projectId: projectId ?? this.projectId,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      done: done ?? this.done,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('projectId: $projectId, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant('folder'));
  static const VerificationMeta _descriptionMeta =
      VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant('#545a94'));
  static const VerificationMeta _sortOrderMeta =
      VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, description, color, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String icon;
  final String? description;
  final String color;
  final int sortOrder;
  Project(
      {required this.id,
      required this.name,
      required this.icon,
      this.description,
      required this.color,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color'] = Variable<String>(color);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: Value(color),
      sortOrder: Value(sortOrder),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<String>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<String>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Project copyWith(
          {String? id,
          String? name,
          String? icon,
          Value<String?> description = const Value.absent(),
          String? color,
          int? sortOrder}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        description: description.present ? description.value : this.description,
        color: color ?? this.color,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      description:
          data.description.present ? data.description.value : this.description,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, description, color, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.description == this.description &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String?> description;
  final Value<String> color;
  final Value<int> sortOrder;
  final Value<int> rowid;
  ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? description,
    Expression<String>? color,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? icon,
      Value<String?>? description,
      Value<String>? color,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTable extends Subtasks with TableInfo<$SubtasksTable, Subtask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doneMeta = VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
      'done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("done" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _sortOrderMeta =
      VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, taskId, title, done, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(Insertable<Subtask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['text']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subtask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subtask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      done: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}done'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $SubtasksTable createAlias(String alias) {
    return $SubtasksTable(attachedDatabase, alias);
  }
}

class Subtask extends DataClass implements Insertable<Subtask> {
  final String id;
  final String taskId;
  final String title;
  final bool done;
  final int sortOrder;
  Subtask(
      {required this.id,
      required this.taskId,
      required this.title,
      required this.done,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['text'] = Variable<String>(title);
    map['done'] = Variable<bool>(done);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SubtasksCompanion toCompanion(bool nullToAbsent) {
    return SubtasksCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      done: Value(done),
      sortOrder: Value(sortOrder),
    );
  }

  factory Subtask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subtask(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      done: serializer.fromJson<bool>(json['done']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'done': serializer.toJson<bool>(done),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Subtask copyWith(
          {String? id,
          String? taskId,
          String? title,
          bool? done,
          int? sortOrder}) =>
      Subtask(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        done: done ?? this.done,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Subtask copyWithCompanion(SubtasksCompanion data) {
    return Subtask(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      done: data.done.present ? data.done.value : this.done,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subtask(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, title, done, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subtask &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.done == this.done &&
          other.sortOrder == this.sortOrder);
}

class SubtasksCompanion extends UpdateCompanion<Subtask> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> done;
  final Value<int> sortOrder;
  final Value<int> rowid;
  SubtasksCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksCompanion.insert({
    required String id,
    required String taskId,
    required String title,
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        title = Value(title);
  static Insertable<Subtask> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<bool>? done,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'text': title,
      if (done != null) 'done': done,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? title,
      Value<bool>? done,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return SubtasksCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      done: done ?? this.done,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['text'] = Variable<String>(title.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrencesTable extends Recurrences
    with TableInfo<$RecurrencesTable, Recurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intervalMeta =
      VerificationMeta('interval');
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
      'interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(1));
  static const VerificationMeta _weekdaysMeta =
      VerificationMeta('weekdays');
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
      'weekdays', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _nextDueMeta =
      VerificationMeta('nextDue');
  @override
  late final GeneratedColumn<DateTime> nextDue = GeneratedColumn<DateTime>(
      'next_due', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, type, interval, weekdays, endDate, nextDue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrences';
  @override
  VerificationContext validateIntegrity(Insertable<Recurrence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    }
    if (data.containsKey('weekdays')) {
      context.handle(_weekdaysMeta,
          weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('next_due')) {
      context.handle(_nextDueMeta,
          nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta));
    } else if (isInserting) {
      context.missing(_nextDueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recurrence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval'])!,
      weekdays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekdays']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      nextDue: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due'])!,
    );
  }

  @override
  $RecurrencesTable createAlias(String alias) {
    return $RecurrencesTable(attachedDatabase, alias);
  }
}

class Recurrence extends DataClass implements Insertable<Recurrence> {
  final String id;
  final String taskId;

  /// 'daily' | 'weekly' | 'monthly'
  final String type;
  final int interval;

  /// JSON list of weekday ints e.g. "[1,3,5]" (Mon=1 … Sun=7)
  final String? weekdays;
  final DateTime? endDate;
  final DateTime nextDue;
  Recurrence(
      {required this.id,
      required this.taskId,
      required this.type,
      required this.interval,
      this.weekdays,
      this.endDate,
      required this.nextDue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['type'] = Variable<String>(type);
    map['interval'] = Variable<int>(interval);
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['next_due'] = Variable<DateTime>(nextDue);
    return map;
  }

  RecurrencesCompanion toCompanion(bool nullToAbsent) {
    return RecurrencesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      type: Value(type),
      interval: Value(interval),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      nextDue: Value(nextDue),
    );
  }

  factory Recurrence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recurrence(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      interval: serializer.fromJson<int>(json['interval']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      nextDue: serializer.fromJson<DateTime>(json['nextDue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(type),
      'interval': serializer.toJson<int>(interval),
      'weekdays': serializer.toJson<String?>(weekdays),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'nextDue': serializer.toJson<DateTime>(nextDue),
    };
  }

  Recurrence copyWith(
          {String? id,
          String? taskId,
          String? type,
          int? interval,
          Value<String?> weekdays = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          DateTime? nextDue}) =>
      Recurrence(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        type: type ?? this.type,
        interval: interval ?? this.interval,
        weekdays: weekdays.present ? weekdays.value : this.weekdays,
        endDate: endDate.present ? endDate.value : this.endDate,
        nextDue: nextDue ?? this.nextDue,
      );
  Recurrence copyWithCompanion(RecurrencesCompanion data) {
    return Recurrence(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      interval: data.interval.present ? data.interval.value : this.interval,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recurrence(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('interval: $interval, ')
          ..write('weekdays: $weekdays, ')
          ..write('endDate: $endDate, ')
          ..write('nextDue: $nextDue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, type, interval, weekdays, endDate, nextDue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recurrence &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.interval == this.interval &&
          other.weekdays == this.weekdays &&
          other.endDate == this.endDate &&
          other.nextDue == this.nextDue);
}

class RecurrencesCompanion extends UpdateCompanion<Recurrence> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> type;
  final Value<int> interval;
  final Value<String?> weekdays;
  final Value<DateTime?> endDate;
  final Value<DateTime> nextDue;
  final Value<int> rowid;
  RecurrencesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.interval = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.endDate = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrencesCompanion.insert({
    required String id,
    required String taskId,
    required String type,
    this.interval = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.endDate = const Value.absent(),
    required DateTime nextDue,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        type = Value(type),
        nextDue = Value(nextDue);
  static Insertable<Recurrence> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<int>? interval,
    Expression<String>? weekdays,
    Expression<DateTime>? endDate,
    Expression<DateTime>? nextDue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (interval != null) 'interval': interval,
      if (weekdays != null) 'weekdays': weekdays,
      if (endDate != null) 'end_date': endDate,
      if (nextDue != null) 'next_due': nextDue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? type,
      Value<int>? interval,
      Value<String?>? weekdays,
      Value<DateTime?>? endDate,
      Value<DateTime>? nextDue,
      Value<int>? rowid}) {
    return RecurrencesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      interval: interval ?? this.interval,
      weekdays: weekdays ?? this.weekdays,
      endDate: endDate ?? this.endDate,
      nextDue: nextDue ?? this.nextDue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<DateTime>(nextDue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrencesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('interval: $interval, ')
          ..write('weekdays: $weekdays, ')
          ..write('endDate: $endDate, ')
          ..write('nextDue: $nextDue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeLogsTable extends TimeLogs with TableInfo<$TimeLogsTable, TimeLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _durationMinsMeta =
      VerificationMeta('durationMins');
  @override
  late final GeneratedColumn<int> durationMins = GeneratedColumn<int>(
      'duration_mins', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, startedAt, endedAt, durationMins];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_logs';
  @override
  VerificationContext validateIntegrity(Insertable<TimeLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    if (data.containsKey('duration_mins')) {
      context.handle(
          _durationMinsMeta,
          durationMins.isAcceptableOrUnknown(
              data['duration_mins']!, _durationMinsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
      durationMins: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_mins']),
    );
  }

  @override
  $TimeLogsTable createAlias(String alias) {
    return $TimeLogsTable(attachedDatabase, alias);
  }
}

class TimeLog extends DataClass implements Insertable<TimeLog> {
  final String id;
  final String taskId;
  final DateTime startedAt;
  final DateTime? endedAt;

  /// Computed and stored when the timer is stopped.
  final int? durationMins;
  TimeLog(
      {required this.id,
      required this.taskId,
      required this.startedAt,
      this.endedAt,
      this.durationMins});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || durationMins != null) {
      map['duration_mins'] = Variable<int>(durationMins);
    }
    return map;
  }

  TimeLogsCompanion toCompanion(bool nullToAbsent) {
    return TimeLogsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationMins: durationMins == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMins),
    );
  }

  factory TimeLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeLog(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationMins: serializer.fromJson<int?>(json['durationMins']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationMins': serializer.toJson<int?>(durationMins),
    };
  }

  TimeLog copyWith(
          {String? id,
          String? taskId,
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent(),
          Value<int?> durationMins = const Value.absent()}) =>
      TimeLog(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
        durationMins:
            durationMins.present ? durationMins.value : this.durationMins,
      );
  TimeLog copyWithCompanion(TimeLogsCompanion data) {
    return TimeLog(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationMins: data.durationMins.present
          ? data.durationMins.value
          : this.durationMins,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeLog(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMins: $durationMins')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, startedAt, endedAt, durationMins);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeLog &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationMins == this.durationMins);
}

class TimeLogsCompanion extends UpdateCompanion<TimeLog> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationMins;
  final Value<int> rowid;
  TimeLogsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMins = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeLogsCompanion.insert({
    required String id,
    required String taskId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationMins = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        startedAt = Value(startedAt);
  static Insertable<TimeLog> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationMins,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationMins != null) 'duration_mins': durationMins,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int?>? durationMins,
      Value<int>? rowid}) {
    return TimeLogsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMins: durationMins ?? this.durationMins,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationMins.present) {
      map['duration_mins'] = Variable<int>(durationMins.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeLogsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMins: $durationMins, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $SubtasksTable subtasks = $SubtasksTable(this);
  late final $RecurrencesTable recurrences = $RecurrencesTable(this);
  late final $TimeLogsTable timeLogs = $TimeLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tasks, projects, subtasks, recurrences, timeLogs];
}

typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  Value<String?> notes,
  Value<String?> projectId,
  Value<int> priority,
  Value<DateTime?> dueDate,
  Value<int?> reminderMinutes,
  Value<bool> done,
  Value<int> sortOrder,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> notes,
  Value<String?> projectId,
  Value<int> priority,
  Value<DateTime?> dueDate,
  Value<int?> reminderMinutes,
  Value<bool> done,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
      column: $table.reminderMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
      column: $table.reminderMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
      column: $table.reminderMinutes, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int?> reminderMinutes = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            notes: notes,
            projectId: projectId,
            priority: priority,
            dueDate: dueDate,
            reminderMinutes: reminderMinutes,
            done: done,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> notes = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int?> reminderMinutes = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            notes: notes,
            projectId: projectId,
            priority: priority,
            dueDate: dueDate,
            reminderMinutes: reminderMinutes,
            done: done,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()>;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  Value<String> icon,
  Value<String?> description,
  Value<String> color,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<String?> description,
  Value<String> color,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
    Project,
    PrefetchHooks Function()> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            icon: icon,
            description: description,
            color: color,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> icon = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            description: description,
            color: color,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
    Project,
    PrefetchHooks Function()>;
typedef $$SubtasksTableCreateCompanionBuilder = SubtasksCompanion Function({
  required String id,
  required String taskId,
  required String title,
  Value<bool> done,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$SubtasksTableUpdateCompanionBuilder = SubtasksCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> title,
  Value<bool> done,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$SubtasksTableFilterComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$SubtasksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$SubtasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SubtasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubtasksTable,
    Subtask,
    $$SubtasksTableFilterComposer,
    $$SubtasksTableOrderingComposer,
    $$SubtasksTableAnnotationComposer,
    $$SubtasksTableCreateCompanionBuilder,
    $$SubtasksTableUpdateCompanionBuilder,
    (Subtask, BaseReferences<_$AppDatabase, $SubtasksTable, Subtask>),
    Subtask,
    PrefetchHooks Function()> {
  $$SubtasksTableTableManager(_$AppDatabase db, $SubtasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtasksCompanion(
            id: id,
            taskId: taskId,
            title: title,
            done: done,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String title,
            Value<bool> done = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtasksCompanion.insert(
            id: id,
            taskId: taskId,
            title: title,
            done: done,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubtasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubtasksTable,
    Subtask,
    $$SubtasksTableFilterComposer,
    $$SubtasksTableOrderingComposer,
    $$SubtasksTableAnnotationComposer,
    $$SubtasksTableCreateCompanionBuilder,
    $$SubtasksTableUpdateCompanionBuilder,
    (Subtask, BaseReferences<_$AppDatabase, $SubtasksTable, Subtask>),
    Subtask,
    PrefetchHooks Function()>;
typedef $$RecurrencesTableCreateCompanionBuilder = RecurrencesCompanion
    Function({
  required String id,
  required String taskId,
  required String type,
  Value<int> interval,
  Value<String?> weekdays,
  Value<DateTime?> endDate,
  required DateTime nextDue,
  Value<int> rowid,
});
typedef $$RecurrencesTableUpdateCompanionBuilder = RecurrencesCompanion
    Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> type,
  Value<int> interval,
  Value<String?> weekdays,
  Value<DateTime?> endDate,
  Value<DateTime> nextDue,
  Value<int> rowid,
});

class $$RecurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDue => $composableBuilder(
      column: $table.nextDue, builder: (column) => ColumnFilters(column));
}

class $$RecurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDue => $composableBuilder(
      column: $table.nextDue, builder: (column) => ColumnOrderings(column));
}

class $$RecurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);
}

class $$RecurrencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurrencesTable,
    Recurrence,
    $$RecurrencesTableFilterComposer,
    $$RecurrencesTableOrderingComposer,
    $$RecurrencesTableAnnotationComposer,
    $$RecurrencesTableCreateCompanionBuilder,
    $$RecurrencesTableUpdateCompanionBuilder,
    (Recurrence, BaseReferences<_$AppDatabase, $RecurrencesTable, Recurrence>),
    Recurrence,
    PrefetchHooks Function()> {
  $$RecurrencesTableTableManager(_$AppDatabase db, $RecurrencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> interval = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime> nextDue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrencesCompanion(
            id: id,
            taskId: taskId,
            type: type,
            interval: interval,
            weekdays: weekdays,
            endDate: endDate,
            nextDue: nextDue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String type,
            Value<int> interval = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            required DateTime nextDue,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrencesCompanion.insert(
            id: id,
            taskId: taskId,
            type: type,
            interval: interval,
            weekdays: weekdays,
            endDate: endDate,
            nextDue: nextDue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurrencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurrencesTable,
    Recurrence,
    $$RecurrencesTableFilterComposer,
    $$RecurrencesTableOrderingComposer,
    $$RecurrencesTableAnnotationComposer,
    $$RecurrencesTableCreateCompanionBuilder,
    $$RecurrencesTableUpdateCompanionBuilder,
    (Recurrence, BaseReferences<_$AppDatabase, $RecurrencesTable, Recurrence>),
    Recurrence,
    PrefetchHooks Function()>;
typedef $$TimeLogsTableCreateCompanionBuilder = TimeLogsCompanion Function({
  required String id,
  required String taskId,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<int?> durationMins,
  Value<int> rowid,
});
typedef $$TimeLogsTableUpdateCompanionBuilder = TimeLogsCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int?> durationMins,
  Value<int> rowid,
});

class $$TimeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMins => $composableBuilder(
      column: $table.durationMins, builder: (column) => ColumnFilters(column));
}

class $$TimeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMins => $composableBuilder(
      column: $table.durationMins,
      builder: (column) => ColumnOrderings(column));
}

class $$TimeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMins => $composableBuilder(
      column: $table.durationMins, builder: (column) => column);
}

class $$TimeLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TimeLogsTable,
    TimeLog,
    $$TimeLogsTableFilterComposer,
    $$TimeLogsTableOrderingComposer,
    $$TimeLogsTableAnnotationComposer,
    $$TimeLogsTableCreateCompanionBuilder,
    $$TimeLogsTableUpdateCompanionBuilder,
    (TimeLog, BaseReferences<_$AppDatabase, $TimeLogsTable, TimeLog>),
    TimeLog,
    PrefetchHooks Function()> {
  $$TimeLogsTableTableManager(_$AppDatabase db, $TimeLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int?> durationMins = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TimeLogsCompanion(
            id: id,
            taskId: taskId,
            startedAt: startedAt,
            endedAt: endedAt,
            durationMins: durationMins,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required DateTime startedAt,
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int?> durationMins = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TimeLogsCompanion.insert(
            id: id,
            taskId: taskId,
            startedAt: startedAt,
            endedAt: endedAt,
            durationMins: durationMins,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TimeLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TimeLogsTable,
    TimeLog,
    $$TimeLogsTableFilterComposer,
    $$TimeLogsTableOrderingComposer,
    $$TimeLogsTableAnnotationComposer,
    $$TimeLogsTableCreateCompanionBuilder,
    $$TimeLogsTableUpdateCompanionBuilder,
    (TimeLog, BaseReferences<_$AppDatabase, $TimeLogsTable, TimeLog>),
    TimeLog,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db, _db.subtasks);
  $$RecurrencesTableTableManager get recurrences =>
      $$RecurrencesTableTableManager(_db, _db.recurrences);
  $$TimeLogsTableTableManager get timeLogs =>
      $$TimeLogsTableTableManager(_db, _db.timeLogs);
}

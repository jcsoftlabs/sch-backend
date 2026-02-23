import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/household_model.dart';
import '../models/household_member_model.dart';

class OfflineHouseholdsRepository {
  final AppDatabase _db;

  OfflineHouseholdsRepository(this._db);

  // ==================== HOUSEHOLDS ====================

  /// Get all households from local database
  Future<List<HouseholdModel>> getAllHouseholds() async {
    final households = await _db.select(_db.households).get();
    return households.map(_householdFromDb).toList();
  }

  /// Get household by ID from local database
  Future<HouseholdModel?> getHouseholdById(String id) async {
    final household = await (_db.select(_db.households)
          ..where((h) => h.id.equals(id)))
        .getSingleOrNull();
    return household != null ? _householdFromDb(household) : null;
  }

  /// Get households by agent ID
  Future<List<HouseholdModel>> getHouseholdsByAgent(String agentId) async {
    final households = await (_db.select(_db.households)
          ..where((h) => h.agentId.equals(agentId)))
        .get();
    return households.map(_householdFromDb).toList();
  }

  /// Save household to local database
  Future<void> saveHousehold(HouseholdModel household) async {
    await _db.into(_db.households).insertOnConflictUpdate(
          _householdToDb(household),
        );
  }

  /// Save multiple households
  Future<void> saveHouseholds(List<HouseholdModel> households) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.households,
        households.map(_householdToDb).toList(),
      );
    });
  }

  /// Delete household from local database
  Future<void> deleteHousehold(String id) async {
    await (_db.delete(_db.households)..where((h) => h.id.equals(id))).go();
  }

  /// Get unsynced households
  Future<List<HouseholdModel>> getUnsyncedHouseholds() async {
    final households = await (_db.select(_db.households)
          ..where((h) => h.syncStatus.equals('pending')))
        .get();
    return households.map(_householdFromDb).toList();
  }

  /// Mark household as synced
  Future<void> markHouseholdAsSynced(String id) async {
    await (_db.update(_db.households)..where((h) => h.id.equals(id)))
        .write(HouseholdsCompanion(syncStatus: const Value('synced')));
  }

  // ==================== HOUSEHOLD MEMBERS ====================

  /// Get all members of a household
  Future<List<HouseholdMemberModel>> getHouseholdMembers(
      String householdId) async {
    final members = await (_db.select(_db.householdMembers)
          ..where((m) => m.householdId.equals(householdId)))
        .get();
    return members.map(_memberFromDb).toList();
  }

  /// Get member by ID
  Future<HouseholdMemberModel?> getMemberById(String id) async {
    final member = await (_db.select(_db.householdMembers)
          ..where((m) => m.id.equals(id)))
        .getSingleOrNull();
    return member != null ? _memberFromDb(member) : null;
  }

  /// Save household member
  Future<void> saveMember(HouseholdMemberModel member) async {
    await _db.into(_db.householdMembers).insertOnConflictUpdate(
          _memberToDb(member),
        );
  }

  /// Save multiple members
  Future<void> saveMembers(List<HouseholdMemberModel> members) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.householdMembers,
        members.map(_memberToDb).toList(),
      );
    });
  }

  /// Delete member
  Future<void> deleteMember(String id) async {
    await (_db.delete(_db.householdMembers)..where((m) => m.id.equals(id)))
        .go();
  }

  /// Get unsynced members
  Future<List<HouseholdMemberModel>> getUnsyncedMembers() async {
    final members = await (_db.select(_db.householdMembers)
          ..where((m) => m.syncStatus.equals('pending')))
        .get();
    return members.map(_memberFromDb).toList();
  }

  /// Mark member as synced
  Future<void> markMemberAsSynced(String id) async {
    await (_db.update(_db.householdMembers)..where((m) => m.id.equals(id)))
        .write(HouseholdMembersCompanion(syncStatus: const Value('synced')));
  }

  // ==================== CONVERTERS ====================

  HouseholdModel _householdFromDb(Household h) {
    return HouseholdModel(
      id: h.id,
      householdHeadName: h.householdHeadName,
      address: h.address,
      neighborhood: h.neighborhood,
      commune: h.commune,
      phone: h.phone,
      latitude: h.gpsLat ?? 0.0,
      longitude: h.gpsLng ?? 0.0,
      gpsAccuracy: h.gpsAccuracy,
      housingType: h.housingType,
      numberOfRooms: h.numberOfRooms,
      waterSource: h.waterSource,
      sanitationType: h.sanitationType,
      hasElectricity: h.hasElectricity ?? false,
      memberCount: h.memberCount ?? 0,
      agentId: h.agentId,
      createdAt: h.createdAt,
      updatedAt: h.updatedAt,
      isSynced: h.syncStatus == 'synced',
    );
  }

  HouseholdsCompanion _householdToDb(HouseholdModel h) {
    return HouseholdsCompanion.insert(
      id: h.id ?? '',
      householdHeadName: h.householdHeadName,
      address: h.address,
      neighborhood: Value(h.neighborhood),
      commune: Value(h.commune),
      phone: Value(h.phone),
      gpsLat: Value(h.latitude),
      gpsLng: Value(h.longitude),
      gpsAccuracy: Value(h.gpsAccuracy),
      zone: '', // required by DB schema (not on HouseholdModel)
      housingType: Value(h.housingType),
      numberOfRooms: Value(h.numberOfRooms),
      waterSource: Value(h.waterSource),
      sanitationType: Value(h.sanitationType),
      hasElectricity: Value(h.hasElectricity),
      memberCount: Value(h.memberCount),
      agentId: h.agentId ?? '',
      createdAt: h.createdAt ?? DateTime.now(),
      updatedAt: h.updatedAt ?? DateTime.now(),
      syncStatus: Value(h.isSynced ? 'synced' : 'pending'),
    );
  }

  HouseholdMemberModel _memberFromDb(HouseholdMember m) {
    return HouseholdMemberModel(
      id: m.id,
      householdId: m.householdId,
      fullName: m.fullName,
      dateOfBirth: m.dateOfBirth,
      gender: m.gender,
      relationshipToHead: m.relationshipToHead,
      educationLevel: m.educationLevel,
      occupation: m.occupation,
      hasHealthInsurance: m.hasHealthInsurance,
      insuranceProvider: m.insuranceProvider,
      chronicConditions: m.chronicConditions != null
          ? (m.chronicConditions!.split(',').where((s) => s.isNotEmpty).toList())
          : null,
      patientId: m.patientId,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      isSynced: m.syncStatus == 'synced',
    );
  }

  HouseholdMembersCompanion _memberToDb(HouseholdMemberModel m) {
    return HouseholdMembersCompanion.insert(
      id: m.id ?? '',
      householdId: m.householdId ?? '',
      fullName: m.fullName,
      dateOfBirth: m.dateOfBirth,
      gender: m.gender,
      relationshipToHead: m.relationshipToHead,
      educationLevel: Value(m.educationLevel),
      occupation: Value(m.occupation),
      hasHealthInsurance: Value(m.hasHealthInsurance),
      insuranceProvider: Value(m.insuranceProvider),
      chronicConditions: Value(m.chronicConditions?.join(',')),
      patientId: Value(m.patientId),
      createdAt: m.createdAt ?? DateTime.now(),
      updatedAt: m.updatedAt ?? DateTime.now(),
      syncStatus: Value(m.isSynced ? 'synced' : 'pending'),
    );
  }

  // ==================== CLEAR DATA ====================

  /// Clear all households (for testing/logout)
  Future<void> clearAllHouseholds() async {
    await _db.delete(_db.households).go();
  }

  /// Clear all members (for testing/logout)
  Future<void> clearAllMembers() async {
    await _db.delete(_db.householdMembers).go();
  }
}

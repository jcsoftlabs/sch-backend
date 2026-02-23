/// Represents a specific step in the national vaccination schedule
class VaccineSchedule {
  final String vaccineName;
  final int doseNumber;
  final int? weeksWaitUntilNextDose;
  final String targetAge;

  const VaccineSchedule({
    required this.vaccineName,
    required this.doseNumber,
    this.weeksWaitUntilNextDose,
    required this.targetAge,
  });
}

/// Central definition of the local vaccination protocol
/// Useful for automatically calculating the follow-up date for a child
class VaccinationProtocol {
  static const List<VaccineSchedule> schedule = [
    // À la naissance
    VaccineSchedule(vaccineName: 'BCG', doseNumber: 1, weeksWaitUntilNextDose: null, targetAge: 'Naissance'),
    VaccineSchedule(vaccineName: 'VPO (Polio oral)', doseNumber: 0, weeksWaitUntilNextDose: 6, targetAge: 'Naissance'),

    // 6 semaines
    VaccineSchedule(vaccineName: 'VPO (Polio oral)', doseNumber: 1, weeksWaitUntilNextDose: 4, targetAge: '6ème semaine'),
    VaccineSchedule(vaccineName: 'Penta', doseNumber: 1, weeksWaitUntilNextDose: 4, targetAge: '6ème semaine'),
    VaccineSchedule(vaccineName: 'Rota', doseNumber: 1, weeksWaitUntilNextDose: 4, targetAge: '6ème semaine'),
    VaccineSchedule(vaccineName: 'PCV (Pneumocoque)', doseNumber: 1, weeksWaitUntilNextDose: 4, targetAge: '6ème semaine'),

    // 10 semaines
    VaccineSchedule(vaccineName: 'VPO (Polio oral)', doseNumber: 2, weeksWaitUntilNextDose: 4, targetAge: '10ème semaine'),
    VaccineSchedule(vaccineName: 'Penta', doseNumber: 2, weeksWaitUntilNextDose: 4, targetAge: '10ème semaine'),
    VaccineSchedule(vaccineName: 'Rota', doseNumber: 2, weeksWaitUntilNextDose: null, targetAge: '10ème semaine'), // Fin Rota
    VaccineSchedule(vaccineName: 'PCV (Pneumocoque)', doseNumber: 2, weeksWaitUntilNextDose: 4, targetAge: '10ème semaine'),

    // 14 semaines
    VaccineSchedule(vaccineName: 'VPO (Polio oral)', doseNumber: 3, weeksWaitUntilNextDose: null, targetAge: '14ème semaine'),
    VaccineSchedule(vaccineName: 'VPI (Polio inj)', doseNumber: 1, weeksWaitUntilNextDose: null, targetAge: '14ème semaine'),
    VaccineSchedule(vaccineName: 'Penta', doseNumber: 3, weeksWaitUntilNextDose: null, targetAge: '14ème semaine'),
    VaccineSchedule(vaccineName: 'PCV (Pneumocoque)', doseNumber: 3, weeksWaitUntilNextDose: null, targetAge: '14ème semaine'),

    // 9 mois
    VaccineSchedule(vaccineName: 'RR (Rougeole Rubéole)', doseNumber: 1, weeksWaitUntilNextDose: null, targetAge: '9 mois'),
    VaccineSchedule(vaccineName: 'VAA (Fièvre Jaune)', doseNumber: 1, weeksWaitUntilNextDose: null, targetAge: '9 mois'),
  ];

  /// Get available vaccines grouped by their typical schedule
  static List<String> getUniqueVaccineNames() {
    return schedule.map((v) => v.vaccineName).toSet().toList();
  }

  /// Calculates the next expected due date based on the current dose given
  static DateTime? calculateNextDueDate(String vaccineName, int currentDoseNumber, DateTime dateGiven) {
    try {
      final currentSchedule = schedule.firstWhere(
        (v) => v.vaccineName == vaccineName && v.doseNumber == currentDoseNumber,
      );

      if (currentSchedule.weeksWaitUntilNextDose != null) {
        return dateGiven.add(Duration(days: currentSchedule.weeksWaitUntilNextDose! * 7));
      }
    } catch (_) {
      // If we don't have a strict schedule definition for this exact dose, return null
    }
    
    return null;
  }
}

import 'package:app/screens/landlord-utility-meter-screen/components/utility_meter_models.dart';

class UtilityMeterExamples {
  static const UtilityMeterUpdateData february2026 = UtilityMeterUpdateData(
    month: "02/2026",
    rooms: [
      // Landmark A
      RoomMeterData(
        id: "room-101",
        roomNumber: "Phòng 101",
        hostelName: "Landmark A",
        status: RoomStatus.rented,
        electricity: UtilityMeterReading(oldReading: 1240, newReading: 1350),
        water: UtilityMeterReading(oldReading: 450, newReading: 0),
      ),
      RoomMeterData(
        id: "room-102",
        roomNumber: "Phòng 102",
        hostelName: "Landmark A",
        status: RoomStatus.rented,
        electricity: UtilityMeterReading(oldReading: 2105, newReading: 0),
        water: UtilityMeterReading(oldReading: 320, newReading: 0),
      ),
      // Sunny House B
      RoomMeterData(
        id: "room-103",
        roomNumber: "Phòng 103",
        hostelName: "Sunny House B",
        status: RoomStatus.vacant,
        electricity: UtilityMeterReading(oldReading: 890, newReading: 0),
        water: UtilityMeterReading(oldReading: 250, newReading: 0),
      ),
      RoomMeterData(
        id: "room-201",
        roomNumber: "Phòng 201",
        hostelName: "Landmark A",
        status: RoomStatus.rented,
        electricity: UtilityMeterReading(oldReading: 1580, newReading: 0),
        water: UtilityMeterReading(oldReading: 380, newReading: 0),
      ),
      RoomMeterData(
        id: "room-202",
        roomNumber: "Phòng 202",
        hostelName: "Sunny House B",
        status: RoomStatus.rented,
        electricity: UtilityMeterReading(oldReading: 1920, newReading: 0),
        water: UtilityMeterReading(oldReading: 420, newReading: 0),
      ),
    ],
  );
}

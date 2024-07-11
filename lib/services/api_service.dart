import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  //Constructor to initialize the base URL
  ApiService({required this.baseUrl});

//Event endpoints
  //create
  Future<http.Response> createEvent(Map<String, dynamic> eventData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createevent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventData),
    );
    return response;
  }

  //delete
  Future<http.Response> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteevent/$id'));
    return response;
  }

  //update
  Future<http.Response> updateEvent(String id, Map<String, dynamic> eventData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/updateevent/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventData),
    );
    return response;
  }

  //view
  Future<http.Response> viewEvent(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/viewevent/$id'));
    return response;
  }

  //join
  Future<http.Response> joinEvent(String id) async {
    final response = await http.post(Uri.parse('$baseUrl/joinevent/$id'));
    return response;
  }

  //unjoin
  Future<http.Response> unjoinEvent(String id) async {
    final response = await http.post(Uri.parse('$baseUrl/unjoinevent/$id'));
    return response;
  }


//User endpoints
  //register
  Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    return response;
  }

  //login
  Future<http.Response> loginUser(Map<String, dynamic> loginData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );
    return response;
  }

  
//Club endpoints
  //create
  Future<http.Response> createClub(Map<String, dynamic> clubData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createclub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clubData),
    );
    return response;
  }

  //delete
  Future<http.Response> deleteClub(String clubId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/deleteclub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'clubId': clubId}),
    );
    return response;
  }

  //update
  Future<http.Response> updateClub(Map<String, dynamic> clubData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateclub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clubData),
    );
    return response;
  }

  //view members
  Future<http.Response> viewClubMembers(String clubId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewClubMembers'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  //view all clubs
  Future<http.Response> viewAllClubs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewclubs'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  //view my clubs
  Future<http.Response> viewMyClubs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewmyclubs'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  //view club events
  Future<http.Response> viewClubEvents(String clubId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewclubevents'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  //join club
  Future<http.Response> joinClub(String clubId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/joinclub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'clubId': clubId}),
    );
    return response;
  }

  //unjoin club
  Future<http.Response> unjoinClub(String clubId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unjoinclub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'clubId': clubId}),
    );
    return response;
  }
}


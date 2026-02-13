## 0. Where it Starts: `main.dart`
Every Flutter app starts at the `main()` function.
- `void main() async { ... }`: The entry point. We use `async` because we need to check the database (`SharedPreferences`) before starting the UI.
- `MyApp`: This is the root of your app. It decides whether to show the **Login Screen** or the **Dashboard** based on whether a "token" exists.

---

## 1. The Big Picture: How Data Flows
Before we look at the code, understand this "chain of command":
1. **The User** interacts with a **Screen** (e.g., clicks a button).
2. The **Screen** calls a function in the **ApiService**.
3. The **ApiService** sends a request (HTTP) to your **Backend Server**.
4. The **Backend** talks to the **Database** and sends back JSON data.
5. The **ApiService** converts that JSON into a **Model** (a Dart object).
6. The **Screen** uses a **FutureBuilder** to catch that data and display it.

---

## 2. The Service Layer: `ApiService.dart`
This file is the bridge to your backend.

### Key Snippet: `getMyApplications()`
```dart
Future<List<ApplicationModel>> getMyApplications() async {
  // 1. Get the security token from storage
  final token = await _getToken();
  if (token == null) throw Exception('No token found');

  // 2. Make an HTTP 'GET' request to the backend URL
  final response = await http.get(
    Uri.parse('$baseUrl/applications/myapplications'),
    headers: {'Authorization': 'Bearer $token'},
  );

  // 3. If the server says "OK" (status 200)
  if (response.statusCode == 200) {
     // 4. Decode the raw JSON string into a list
     final List<dynamic> data = jsonDecode(response.body);
     // 5. Convert each raw JSON map into an 'ApplicationModel' object
    return data.map((json) => ApplicationModel.fromJson(json)).toList();
  } else {
     throw Exception('Failed to load my applications');
  }
}
```

---

## 3. The Dashboard: `CandidateDashboard.dart`
This is a `StatefulWidget`. This means it can change its look when data arrives.

### The Layout Structure
Every screen follows this "tree" pattern:
- **Scaffold**: The "skeleton" of the page (white background).
  - **AppBar**: The top bar (Title, Refresh button, Logout).
  - **Body**: The main content.
    - **Column**: A vertical list of items.
      - **TextField**: The search bar.
      - **FutureBuilder**: The "waiting room" for data.
        - **ListView.builder**: This is how we show a scrolling list. It's like a "factory" that makes a card for every job in the list.

### The "Waiting Room": `FutureBuilder`
This is how we show data that takes time to fetch.

```dart
FutureBuilder<List<ApplicationModel>>(
  // 'future' tells Flutter WHICH data to fetch
  future: _apiService.getMyApplications(), 
  
  // 'builder' tells Flutter WHAT to show based on the status
  builder: (context, AsyncSnapshot<List<ApplicationModel>> snapshot) {
    // 1. While waiting (no data yet), show nothing (or a spinner)
    if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
    
    // 2. If data arrived, filter it (find upcoming interviews)
    final upcoming = snapshot.data!.where((a) => a.interviewDate != null).toList();
    if (upcoming.isEmpty) return const SizedBox.shrink();

    // 3. Return a Widget (Column) to display the interviews
    return Column(...);
  },
)
```

---

## 4. Special Feature: Interview Scheduling
How does the scheduling work?
1. **Recruiter Screen**: The `JobApplicationsScreen` has a dropdown.
2. **Action**: When the recruiter selects "Interview", a dialog pops up asking for a Date and Location.
3. **API Call**: The `ApiService.scheduleInterview` function sends that info to the backend.
4. **Result**: The application status changes to `interview` in the database.
5. **Dashboard**: The `CandidateDashboard` sees the `interviewDate` is no longer empty and shows the "Upcoming Interviews" card automatically.

---

## 5. Visual "Baby" Concepts
- **Padding**: Adding "breathing room" around a widget.
- **SizedBox**: An invisible box used to create gaps (like a `height: 16`).
- **DecoratedBox / Container**: A box with colors, rounded corners, and shadows (for cards).
- **Navigator.push**: Moving the user from one screen to the next.
- **`as JobModel`**: This is called "Type Casting". It's like telling Flutter: "Trust me, I know this object is a JobModel, so let me access its title."

### How to read common lines:
- `setState(() { ... })`: "Hey Flutter, I just changed some data! Redraw the screen so the user sees the update."
- `onTap: () { ... }`: "When the user clicks this, do this action."
- `Colors.blueAccent.withOpacity(0.1)`: A very light, transparent blue.

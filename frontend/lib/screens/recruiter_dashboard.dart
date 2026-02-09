import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/job_model.dart';
import 'create_job_screen.dart';
import 'job_applications_screen.dart';

class RecruiterDashboard extends StatefulWidget {
  const RecruiterDashboard({super.key});

  @override
  State<RecruiterDashboard> createState() => _RecruiterDashboardState();
}

class _RecruiterDashboardState extends State<RecruiterDashboard> {
  final ApiService _apiService = ApiService();
  late Future<List<JobModel>> _myJobsFuture;

  @override
  void initState() {
    super.initState();
    _refreshJobs();
  }

  void _refreshJobs() {
    setState(() {
      _myJobsFuture = _apiService.getMyJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recruiter Dashboard')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateJobScreen()),
          );
          _refreshJobs();
        },
        icon: const Icon(Icons.add),
        label: const Text('Post New Job'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<JobModel>>(
        future: _myJobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No jobs posted yet.', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            );
          }

          final jobs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobApplicationsScreen(jobId: job.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                job.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateJobScreen(existingJob: job),
                                  ),
                                );
                                _refreshJobs();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(job.location, style: const TextStyle(color: Colors.grey)),
                            const Spacer(),
                            const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${job.applicants.length} Applicants', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

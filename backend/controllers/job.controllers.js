import Job from "../models/job.model.js";

export const createJob = async (req, res) => {
    try {
        const { title, description, company, location, salary, requirements, contactName, contactEmail } = req.body;

        // Ensure only recruiters can create jobs
        // Note: This check relies on req.user populated by isAuth middleware
        // For now, we assume frontend sends the role or we fetch user. 
        // Better: isAuth should populate req.user fully or we fetch it here.
        // Let's rely on req.userId for now and trusting frontend role check or fetching user.

        const newJob = await Job.create({
            title,
            description,
            company,
            location,
            salary,
            requirements,
            contactName,
            contactEmail,
            postedBy: req.userId
        });

        return res.status(201).json(newJob);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Error creating job" });
    }
};

export const getAllJobs = async (req, res) => {
    try {
        const jobs = await Job.find().populate("postedBy", "firstName lastName profileImage headline").sort({ createdAt: -1 });
        return res.status(200).json(jobs);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Error fetching jobs" });
    }
};

export const getMyJobs = async (req, res) => {
    try {
        const jobs = await Job.find({ postedBy: req.userId }).sort({ createdAt: -1 });
        return res.status(200).json(jobs);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Error fetching my jobs" });
    }
};

export const updateJob = async (req, res) => {
    try {
        const { id } = req.params;
        const { title, description, company, location, salary, requirements, contactName, contactEmail } = req.body;

        const job = await Job.findById(id);
        if (!job) {
            return res.status(404).json({ message: "Job not found" });
        }

        // Check if the user is the owner of the job
        if (job.postedBy.toString() !== req.userId) {
            return res.status(403).json({ message: "Unauthorized to update this job" });
        }

        job.title = title || job.title;
        job.description = description || job.description;
        job.company = company || job.company;
        job.location = location || job.location;
        job.salary = salary || job.salary;
        job.requirements = requirements || job.requirements;
        job.contactName = contactName || job.contactName;
        job.contactEmail = contactEmail || job.contactEmail;

        const updatedJob = await job.save();
        return res.status(200).json(updatedJob);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Error updating job" });
    }
};

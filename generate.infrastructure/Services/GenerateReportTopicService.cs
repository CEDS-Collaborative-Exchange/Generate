using System;
using System.Linq;
using System.Collections.Generic;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class GenerateReportTopicService : IGenerateReportTopicService
    {
        private readonly IAppRepository _appRepository;

        private IGenerateReportService _generateReportService;

        public GenerateReportTopicService(
            IAppRepository appRepository,
            IGenerateReportService generateReportService)
        {
            _appRepository = appRepository;
            _generateReportService = generateReportService;
        }

        public List<GenerateReportTopicDto> GetReportTopics(string userName)
        {
            List<GenerateReportTopic> topics = _appRepository.Find<GenerateReportTopic>(r => r.UserName == userName).OrderBy(s => s.GenerateReportTopicName).ToList();

            List<GenerateReportTopicDto> results = new List<GenerateReportTopicDto>();

            foreach (var topic in topics)
            {
                List<GenerateReport> reports = new List<GenerateReport>();
                reports = GetReports(topic.GenerateReportTopicId, 0, 0);

                List<GenerateReportDto> reportDtos = new List<GenerateReportDto>();
                reportDtos = _generateReportService.GetReportDtos(reports);

                GenerateReportTopicDto dto = new GenerateReportTopicDto()
                {
                    GenerateReportTopicId = topic.GenerateReportTopicId,
                    GenerateReportTopicName = topic.GenerateReportTopicName,
                    IsActive = topic.IsActive,
                    UserName = topic.UserName,
                    GenerateReports = reportDtos
                };

                results.Add(dto);
            }

            return results;
        }

        public List<GenerateReport> GetReports(int topicId, int skip = 0, int take = 50)
        {
            GenerateReportTopic topic = _appRepository.Find<GenerateReportTopic>(s => s.GenerateReportTopicId == topicId, skip, take, t => t.GenerateReportTopic_GenerateReports).FirstOrDefault();
            List<GenerateReport> reports = new List<GenerateReport>();

            foreach (GenerateReportTopic_GenerateReport topicReports in topic.GenerateReportTopic_GenerateReports)
            {
                GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportId == topicReports.GenerateReportId, 0 ,1, s => s.GenerateReport_OrganizationLevels).OrderBy(c => c.ReportName).FirstOrDefault();
                reports.Add(report);
            }
            return reports;
        }

        public void AddTopic(GenerateReportTopicDto topic)
        {
            GenerateReportTopic newTopic = new GenerateReportTopic();
            newTopic.GenerateReportTopicName = topic.GenerateReportTopicName;
            newTopic.UserName = topic.UserName;
            newTopic.IsActive = topic.IsActive;
            _appRepository.Create(newTopic);
            _appRepository.Save();

            newTopic = _appRepository.Find<GenerateReportTopic>(r => r.GenerateReportTopicName == topic.GenerateReportTopicName && r.UserName == topic.UserName).FirstOrDefault();

            if (topic.GenerateReports != null)
            {
                List<GenerateReportTopic_GenerateReport> insertRecords = new List<GenerateReportTopic_GenerateReport>();
                foreach (GenerateReportDto report in topic.GenerateReports)
                {
                    GenerateReportTopic_GenerateReport topicReport = new GenerateReportTopic_GenerateReport();
                    topicReport.GenerateReportTopicId = newTopic.GenerateReportTopicId;
                    topicReport.GenerateReportId = report.GenerateReportId;
                    insertRecords.Add(topicReport);
                }

                _appRepository.CreateRange(insertRecords);
                _appRepository.Save();
            }
        }

        public void UpdateTopic(GenerateReportTopicDto topic)
        {
            GenerateReportTopic updateTopic = _appRepository.Find<GenerateReportTopic>(r => r.GenerateReportTopicId == topic.GenerateReportTopicId, 0 ,1, t => t.GenerateReportTopic_GenerateReports).FirstOrDefault();
            updateTopic.GenerateReportTopicName = topic.GenerateReportTopicName;
          

            if (topic.GenerateReports != null)
            {
               
                List<int> removeReportList = updateTopic.GenerateReportTopic_GenerateReports.Select(a => a.GenerateReportId).Except(topic.GenerateReports.Select(c => c.GenerateReportId)).ToList();
                List<int> insertReportList = topic.GenerateReports.Select(a => a.GenerateReportId).Except(updateTopic.GenerateReportTopic_GenerateReports.Select(c => c.GenerateReportId)).ToList();

                foreach (int reportId in insertReportList)
                {
                    GenerateReportTopic_GenerateReport topicReport = new GenerateReportTopic_GenerateReport();
                    topicReport.GenerateReportTopicId = topic.GenerateReportTopicId;
                    topicReport.GenerateReportId = reportId;
                    updateTopic.GenerateReportTopic_GenerateReports.Add(topicReport);
                 }

                foreach (int reportId in removeReportList)
                {
                    updateTopic.GenerateReportTopic_GenerateReports.Remove(updateTopic.GenerateReportTopic_GenerateReports.Single(s => s.GenerateReportId == reportId));
                }

                _appRepository.Update(updateTopic);
                _appRepository.Save();

            }
        }

        public void UpdateReportTopics(int reportId, int[] topicIds)
        {
            List<GenerateReportTopic_GenerateReport> reportTopics = new List<GenerateReportTopic_GenerateReport>();

            _appRepository.DeleteRange(_appRepository.Find<GenerateReportTopic_GenerateReport>(r => r.GenerateReportId == reportId).ToList());
            _appRepository.Save();

            foreach (int topicId in topicIds)
            {
                GenerateReportTopic_GenerateReport topicReport = new GenerateReportTopic_GenerateReport();
                topicReport.GenerateReportTopicId = topicId;
                topicReport.GenerateReportId = reportId;
                reportTopics.Add(topicReport);

            }

            if (reportTopics.Count > 0)
            {
                _appRepository.CreateRange(reportTopics);
                _appRepository.Save();
            }

        }
        public void RemoveTopic(int topicId)
        {
            GenerateReportTopic deleteTopic = _appRepository.Find<GenerateReportTopic>(r => r.GenerateReportTopicId == topicId, 0, 1, t => t.GenerateReportTopic_GenerateReports).FirstOrDefault();

            deleteTopic.GenerateReportTopic_GenerateReports.RemoveAll(t => t.GenerateReportId == t.GenerateReportId);
            _appRepository.Delete<GenerateReportTopic>(topicId);
            _appRepository.Save();
        }
    }
}

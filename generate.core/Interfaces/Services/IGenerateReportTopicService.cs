using System;
using System.Linq;
using System.Collections.Generic;
using generate.core.Models.App;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    public interface IGenerateReportTopicService
    {
        List<GenerateReportTopicDto> GetReportTopics(string userName);
        List<GenerateReport> GetReports(int topicId, int skip = 0, int take = 50);
        void AddTopic(GenerateReportTopicDto topic);
        void UpdateTopic(GenerateReportTopicDto topic);
        void UpdateReportTopics(int reportId, int[] topicIds);
        void RemoveTopic(int topicId);
    }
}

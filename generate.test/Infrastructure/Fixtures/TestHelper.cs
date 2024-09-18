using Moq;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace generate.test.Infrastructure.Fixtures
{
    public static class TestHelper
    {
        public static RestClient MockRestClient<T>(HttpStatusCode httpStatusCode, string json)
            where T : new()
        {
            var data = JsonConvert.DeserializeObject<T>(json);
            var response = new Mock<RestResponse<T>>();
            response.Setup(_ => _.StatusCode).Returns(httpStatusCode);
            response.Setup(_ => _.Data).Returns(data);

            var mockRestClient = new Mock<RestClient>();
            mockRestClient
              .Setup(x => x.Execute<T>(It.IsAny<RestRequest>()))
              .Returns(response.Object);
            return mockRestClient.Object;
        }

    }
}

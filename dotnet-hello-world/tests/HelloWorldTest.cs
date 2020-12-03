using System;
using NetCore.Docker.Pages;
using Xunit;

namespace NetCore.Docker.Pages.UnitTests
{
  public class HelloWorldTest
  {
    [Fact]
    public void IsHostnameCorrect()
    {
      var host = IndexModel.GetHostName();
      Assert.DoesNotContain("local", host);
    }

    [Fact]
    public void IsDotNetOnLTSVersion()
    {
      var version = IndexModel.GetDotNetVersion();
      Assert.Contains("3.1.10", version);
    }
  }
}

using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using SilentID.Api.Data;
using SilentID.Api.Models;
using System.Reflection;
using Xunit;

namespace SilentID.Api.Tests.Security;

/// <summary>
/// CRITICAL: Tests to ensure SilentID remains 100% passwordless
/// These tests MUST pass or the system violates its core security principle
/// </summary>
public class PasswordlessComplianceTests
{
    [Fact]
    public void UserModel_ShouldNotHavePasswordField()
    {
        // Arrange
        var userType = typeof(User);

        // Act
        var properties = userType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
        var passwordProperties = properties.Where(p =>
            p.Name.ToLower().Contains("password") ||
            p.Name.ToLower().Contains("pwd") ||
            p.Name.ToLower().Contains("hash") && p.Name.ToLower().Contains("password")
        ).ToList();

        // Assert
        passwordProperties.Should().BeEmpty(
            "User model MUST NOT contain any password-related fields. SilentID is 100% passwordless."
        );
    }

    [Fact]
    public void Database_ShouldNotHavePasswordColumn()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<SilentIdDbContext>()
            .UseInMemoryDatabase(databaseName: "PasswordCheckDb")
            .Options;

        using var context = new SilentIdDbContext(options);

        // Act
        var userEntityType = context.Model.FindEntityType(typeof(User));
        var properties = userEntityType?.GetProperties() ?? Enumerable.Empty<IProperty>();

        var passwordColumns = properties.Where(p =>
            p.Name.ToLower().Contains("password") ||
            p.Name.ToLower().Contains("pwd")
        ).ToList();

        // Assert
        passwordColumns.Should().BeEmpty(
            "Database schema MUST NOT contain any password columns. SilentID is 100% passwordless."
        );
    }

    [Fact]
    public void SessionModel_ShouldNotHavePasswordField()
    {
        // Arrange
        var sessionType = typeof(Session);

        // Act
        var properties = sessionType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
        var passwordProperties = properties.Where(p =>
            p.Name.ToLower().Contains("password") ||
            p.Name.ToLower().Contains("pwd")
        ).ToList();

        // Assert
        passwordProperties.Should().BeEmpty(
            "Session model MUST NOT contain any password-related fields."
        );
    }

    [Fact]
    public void AllModels_ShouldNotHavePasswordFields()
    {
        // Arrange
        var modelAssembly = typeof(User).Assembly;
        var modelTypes = modelAssembly.GetTypes()
            .Where(t => t.Namespace == "SilentID.Api.Models" && t.IsClass);

        // Act & Assert
        foreach (var modelType in modelTypes)
        {
            var properties = modelType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            var passwordProperties = properties.Where(p =>
                p.Name.ToLower().Contains("password") ||
                p.Name.ToLower().Contains("pwd")
            ).ToList();

            passwordProperties.Should().BeEmpty(
                $"Model {modelType.Name} MUST NOT contain password fields. SilentID is 100% passwordless."
            );
        }
    }

    [Fact]
    public void SourceCode_ShouldNotHaveSetPasswordMethods()
    {
        // Arrange
        var assembly = typeof(User).Assembly;
        var allTypes = assembly.GetTypes();

        // Act
        var forbiddenMethods = new List<string>();

        foreach (var type in allTypes)
        {
            var methods = type.GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static);

            foreach (var method in methods)
            {
                var methodName = method.Name.ToLower();
                if (methodName.Contains("setpassword") ||
                    methodName.Contains("changepassword") ||
                    methodName.Contains("resetpassword") ||
                    methodName.Contains("updatepassword") ||
                    methodName.Contains("hashpassword"))
                {
                    forbiddenMethods.Add($"{type.Name}.{method.Name}");
                }
            }
        }

        // Assert
        forbiddenMethods.Should().BeEmpty(
            "CRITICAL VIOLATION: Found password-related methods. SilentID MUST be 100% passwordless.\n" +
            "Found: " + string.Join(", ", forbiddenMethods)
        );
    }

    [Fact]
    public void SourceCode_ShouldNotHavePasswordConstants()
    {
        // Arrange
        var assembly = typeof(User).Assembly;
        var allTypes = assembly.GetTypes();

        // Act
        var forbiddenConstants = new List<string>();

        foreach (var type in allTypes)
        {
            var fields = type.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);

            foreach (var field in fields)
            {
                var fieldName = field.Name.ToLower();
                if ((fieldName.Contains("password") && !fieldName.Contains("passwordless")) ||
                    fieldName.Contains("pwd") ||
                    fieldName.Contains("pass_") ||
                    fieldName.Contains("_pass"))
                {
                    forbiddenConstants.Add($"{type.Name}.{field.Name}");
                }
            }
        }

        // Assert
        forbiddenConstants.Should().BeEmpty(
            "CRITICAL VIOLATION: Found password-related constants. SilentID MUST be 100% passwordless.\n" +
            "Found: " + string.Join(", ", forbiddenConstants)
        );
    }

    [Fact]
    public void AuthController_ShouldNotHavePasswordEndpoints()
    {
        // Arrange
        var assembly = typeof(User).Assembly;
        var controllers = assembly.GetTypes()
            .Where(t => t.Name.EndsWith("Controller"));

        // Act
        var forbiddenEndpoints = new List<string>();

        foreach (var controller in controllers)
        {
            var methods = controller.GetMethods(BindingFlags.Public | BindingFlags.Instance);

            foreach (var method in methods)
            {
                var methodName = method.Name.ToLower();
                if (methodName.Contains("password") ||
                    methodName.Contains("setpassword") ||
                    methodName.Contains("changepassword") ||
                    methodName.Contains("resetpassword") ||
                    methodName.Contains("forgotpassword"))
                {
                    forbiddenEndpoints.Add($"{controller.Name}.{method.Name}");
                }
            }
        }

        // Assert
        forbiddenEndpoints.Should().BeEmpty(
            "CRITICAL VIOLATION: Found password-related endpoints. SilentID MUST be 100% passwordless.\n" +
            "Found: " + string.Join(", ", forbiddenEndpoints)
        );
    }

    [Fact]
    public void PasswordlessAuthenticationMethods_ShouldExist()
    {
        // Arrange
        var assembly = typeof(User).Assembly;
        var controllers = assembly.GetTypes()
            .Where(t => t.Name == "AuthController")
            .FirstOrDefault();

        controllers.Should().NotBeNull("AuthController should exist");

        // Act
        var methods = controllers!.GetMethods(BindingFlags.Public | BindingFlags.Instance)
            .Select(m => m.Name.ToLower())
            .ToList();

        // Assert
        methods.Should().Contain("requestotp", "OTP authentication method should exist");
        methods.Should().Contain("verifyotp", "OTP verification method should exist");
        methods.Should().Contain("refreshtoken", "Token refresh method should exist");
    }
}

# Local NuGet Package Generation

This solution includes a build system to generate and manage local NuGet packages for all projects. This is particularly useful for development and testing scenarios where you want to use these packages in other solutions.

## Project Structure

The solution contains multiple projects targeting different .NET versions:
- .NET 8
- .NET Standard 2.0
- .NET Core 3.1

## Build and Package Generation

### Setup Files
- `Directory.Build.props`: Contains common properties for all projects including package versioning and output paths
- `build.ps1`: PowerShell script to build the solution and generate packages
- `nuget.config`: NuGet configuration file that defines the local package source

### How to Generate Packages

1. Open PowerShell in the solution directory
2. Run the build script:
   ```powershell
   .\build.ps1
   ```

This will:
- Clean the local-packages directory
- Restore all dependencies
- Build the entire solution in Release mode
- Generate NuGet packages for all projects
- Place all packages in the `local-packages` directory

### Package Output Location

All generated packages will be available in:
```
{SolutionRoot}/local-packages/
```

## Using the Local Packages

### In Another Project

1. Copy the `nuget.config` file to your target solution
2. Update the package source path in `nuget.config` to point to your local packages directory:
   ```xml
   <packageSources>
     <add key="local-shesha-packages" value="PATH_TO_YOUR_SOLUTION/local-packages" />
   </packageSources>
   ```
3. The packages will be available in the NuGet Package Manager in Visual Studio

### Available Packages

The following packages will be generated:
- Shesha.Application
- Shesha.Common
- Shesha.Core
- Shesha.Elmah
- Shesha.Framework
- Shesha.GraphQL
- Shesha.Import
- Shesha.MongoRepository
- Shesha.NHibernate
- Shesha.NHibernate.PostGis
- Shesha.RestSharp
- Shesha.Scheduler
- Shesha.Web.Core
- Shesha.Web.FormsDesigner
- SheshaCodeAnalyzers
- And more...

## Version Management

Package versions are managed centrally in the `Directory.Build.props` file. To update the version for all packages, modify the `Version` property in this file.

## Troubleshooting

1. If packages are not appearing in your target project:
   - Ensure the path in `nuget.config` is correct
   - Clear your local NuGet cache: `dotnenuget locals all --clear`
   - Rebuild the packages using `build.ps1`

2. If build fails:
   - Check that all required .NET SDKs are installed
   - Ensure all package dependencies are available
   - Review the build output for specific error messages

## Notes

- Test projects (*.Tests.* projects) are not packaged
- The build script will always generate Release configuration packages
- Each build will clean the local-packages directory to ensure clean package generation
- The solution uses an existing `local-packages` directory at the solution level for package storage
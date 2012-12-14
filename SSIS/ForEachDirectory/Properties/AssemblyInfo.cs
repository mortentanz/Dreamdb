#region Using directives
using System;
using System.Security.Permissions;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Runtime.CompilerServices;

#endregion

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("ForEachDirectory")]
[assembly: AssemblyDescription("Implements a Directory Enumerator Task")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("DREAM")]
[assembly: AssemblyProduct("Dreamdb")]
[assembly: AssemblyCopyright("Copyright @ Microsoft 2005")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version 
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Revision and Build Numbers 
// by using the '*' as shown below:
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: CLSCompliant(true)]
[assembly: PermissionSet(SecurityAction.RequestMinimum)]
[assembly: ComVisible(false)]
[assembly: System.Runtime.ConstrainedExecution.ReliabilityContract(System.Runtime.ConstrainedExecution.Consistency.MayCorruptInstance, System.Runtime.ConstrainedExecution.Cer.None)]

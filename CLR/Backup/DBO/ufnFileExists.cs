using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Security;
using System.Security.Principal;
using Microsoft.SqlServer.Server;

namespace Dreamdb.dbo.Programmability
{
  public partial class UserDefinedFunctions
  {
    /// <summary>
    /// Call to determine whether a file exists.
    /// </summary>
    /// <param name="fileName">The fully qualified name of the file to test for existence.</param>
    /// <returns>true if the file exists, false if not and null if null is passed in.</returns>
    [Microsoft.SqlServer.Server.SqlFunction(IsDeterministic = false, DataAccess = DataAccessKind.Read)]
    public static SqlBoolean ufnFileExists(SqlString fileName)
    {
      if (fileName.IsNull)
      {
        return new SqlBoolean();
      }
      else
      {
        bool exists;
        using (WindowsIdentity wi = SqlContext.WindowsIdentity)
        {
          WindowsImpersonationContext wic = wi.Impersonate();
          exists = File.Exists(fileName.Value);
          wic.Undo();
        }
        return new SqlBoolean(exists);
      }
    }
  };
}
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Security;
using System.Security.Principal;
using Microsoft.SqlServer.Server;
using System.Collections;
using System.Collections.Generic;

namespace Dreamdb.dbo.Programmability
{

  public partial class UserDefinedFunctions
  {
    /// <summary>
    /// Retrieves a list of files including available file information from a specified directory.
    /// </summary>
    /// <param name="directory">The filesystem directory to search.</param>
    /// <param name="searchPattern">The filename pattern to search against (*.* is assumed on NULL).</param>
    /// <param name="recurse">States whether the search should recurse subdirectories (false is assumed on NULL).</param>
    /// <returns>A tabular recordset containing information on files found.</returns>
    [Microsoft.SqlServer.Server.SqlFunction(
      DataAccess = DataAccessKind.None,
      FillRowMethodName = "FillFileInformationRow",
      TableDefinition = "[Path] nvarchar(255), [Name] nvarchar(255), [Extension] nvarchar(10), [Size] bigint, [Created] datetime, Accessed datetime, Modified datetime, IsReadOnly bit"
    )]
    public static IEnumerable ufnGetDirectoryContents(SqlString path, SqlString pattern, SqlBoolean recurse)
    {
      string p;
      SearchOption o;
      string[] names;
      List<FileInfo> files = new List<FileInfo>();

      p = (pattern.IsNull) ? "*.*" : pattern.Value;

      if (recurse.IsNull || !recurse.Value)
      {
        o = SearchOption.TopDirectoryOnly;
      }
      else
      {
        o = SearchOption.AllDirectories;
      }

      using (WindowsIdentity wi = SqlContext.WindowsIdentity)
      {
        WindowsImpersonationContext wic = wi.Impersonate();
        if (Directory.Exists(path.Value))
        {
          names = Directory.GetFiles(path.Value, p, o);
          foreach (string name in names)
          {
            files.Add(new FileInfo(name));
          }
        }
        wic.Undo();
      }
      return files;
    }

  }
}
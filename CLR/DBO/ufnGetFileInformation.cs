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
    /// Retrives file information for a single file.
    /// </summary>
    /// <param name="filename">The fully qualified path (relative to the server) of the file to return information for.</param>
    /// <returns>A single record recordset containing information on the file.</returns>
    [Microsoft.SqlServer.Server.SqlFunction(
      DataAccess = DataAccessKind.None,
      FillRowMethodName = "FillFileInformationRow",
      TableDefinition = "[Path] nvarchar(255), [Name] nvarchar(255), [Extension] nvarchar(10), [Size] bigint, [Created] datetime, Accessed datetime, Modified datetime, IsReadOnly bit"
    )]
    public static IEnumerable ufnGetFileInformation(SqlString filename)
    {
      List<FileInfo> file = new List<FileInfo>(1);
      using (WindowsIdentity wi = SqlContext.WindowsIdentity)
      {
        WindowsImpersonationContext wic = wi.Impersonate();
        if (File.Exists(filename.Value))
        {
          file.Add(new FileInfo(filename.Value));
        }
        wic.Undo();
      }
      return file;
    }

    /// <summary>
    /// Method filling a record, called once per FileInfo located by ufnGetFileAttributes.
    /// </summary>
    /// <param name="o">A FileInfo object.</param>
    /// <param name="path">Qualified name of directory containing the file.</param>
    /// <param name="name">The name of the file.</param>
    /// <param name="extension">The extension part of the file.</param>
    /// <param name="size">The filesize measured in bytes.</param>
    /// <param name="created">UTC time of creation.</param>
    /// <param name="accessed">UTC time of last access.</param>
    /// <param name="modified">UTC time of last write.</param>
    /// <param name="isReadOnly">States if the read-only attribute is set on the file.</param>
    public static void FillFileInformationRow(
      object o,
      out SqlString path,
      out SqlString name,
      out SqlString extension,
      out SqlInt64 size,
      out SqlDateTime created,
      out SqlDateTime accessed,
      out SqlDateTime modified,
      out SqlBoolean isReadOnly
    )
    {
      FileInfo file = (FileInfo)o;
      path = new SqlString(file.DirectoryName);
      name = new SqlString(file.Name);
      extension = new SqlString(file.Extension);
      size = new SqlInt64(file.Length);
      created = new SqlDateTime(file.CreationTimeUtc);
      accessed = new SqlDateTime(file.LastAccessTimeUtc);
      modified = new SqlDateTime(file.LastWriteTimeUtc);
      isReadOnly = new SqlBoolean(file.IsReadOnly);
    }

  };

}
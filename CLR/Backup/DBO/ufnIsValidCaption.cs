using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using Microsoft.SqlServer.Server;

namespace Dreamdb.dbo.Programmability
{

  public partial class UserDefinedFunctions
  {
    /// <summary>
    /// User-defined scalar-valued function testing whether a string is valid for use as identification captions.
    /// </summary>
    /// <param name="caption">The string to test for system compliance.</param>
    /// <returns>True if the caption is without spaces and file system special characters, false otherwise.</returns>
    [Microsoft.SqlServer.Server.SqlFunction(DataAccess=DataAccessKind.None, IsDeterministic=true)]
    public static SqlBoolean ufnIsValidCaption(SqlString caption)
    {
      if (caption.IsNull) return new SqlBoolean(false);
      Regex filerex = new Regex("([^\\s\\\\/:*?<>|]+)");
      return new SqlBoolean(filerex.Matches(caption.Value).Count == 1);
    }
  };
}

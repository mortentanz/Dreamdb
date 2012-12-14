#region Source file version
// $Archive: /CLR.root/CLR/ETL/ufnParseDSTabSource.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: ufnParseDSTabSource.cs $
// $Modtime: 10/02/06 13:05 $
#endregion
        
using System;
using System.Collections;
using System.Data.SqlTypes;
using System.IO;
using System.Security.Principal;
using Dreamdb.ETL.Text;
using Microsoft.SqlServer.Server;

namespace Dreamdb.ETL.Programmability
{
  public partial class UserDefinedFunctions
  {
    /// <summary>
    /// Table valued function for returning the result of parsing a set of files in the DSTab file format.
    /// </summary>
    /// <param name="searchpath">A top-level directory to search for DSTab files.</param>
    /// <param name="contentpattern">A four-letter code describing what subject to return.</param>
    /// <returns>A tabular result that needs to be normalized to the schema used for the actual base tables.</returns>
    [Microsoft.SqlServer.Server.SqlFunction(
      DataAccess = DataAccessKind.None,
      FillRowMethodName = "FillDSTabRecord",
      TableDefinition = "ContentCode nvarchar(10), OriginCode nvarchar(8), Age tinyint, Year smallint, Male int, Female int, Total int")]
    public static IEnumerable ufnParseDSTabSource(SqlString path, SqlString pattern)
    {
      string[] filenames;
      using (WindowsIdentity wi = SqlContext.WindowsIdentity)
      {
        WindowsImpersonationContext wic = wi.Impersonate();
        filenames = Directory.GetFiles(path.Value, pattern.Value, SearchOption.AllDirectories);
        wic.Undo();
      }

      DSTabRecordFormat f = new DSTabRecordFormat();
      TextRecordParser p = new TextRecordParser(f);
      p.SetInput(filenames);
      return p;
    }

    /// <summary>
    /// Callback function for the ParseDSTabFiles method (called by SQL Server).
    /// </summary>
    /// <param name="record">A TextRecord containing a single record.</param>
    /// <param name="Content">A four-letter code describing the subject of the record.</param>
    /// <param name="OriginCode">A code for the origin of the group of persons as encoded in the file name.</param>
    /// <param name="Age">The age of the group of persons.</param>
    /// <param name="Year">The year of the observation.</param>
    /// <param name="Male">The number of male persons.</param>
    /// <param name="Female">The number of female persons.</param>
    /// <param name="Total">The total number of persons.</param>
    public static void FillDSTabRecord(
      object record,
      out SqlString Content,
      out SqlString OriginCode,
      out SqlByte Age,
      out SqlInt16 Year,
      out SqlInt32 Male,
      out SqlInt32 Female,
      out SqlInt32 Total
    )
    {
      TextRecord r = (TextRecord)record;

      Content = new SqlString(r["contentcode"].ToString());
      OriginCode = new SqlString(r["origincode"].ToString());
      Age = new SqlByte(byte.Parse(r.GetValue(r.GetOrdinal("age"))));
      int y = int.Parse(r.GetValue(r.GetOrdinal("year")));
      y = (y < 79) ? 2000 + y : 1900 + y;
      Year = new SqlInt16((short)y);
      Male = new SqlInt32(int.Parse(r.GetValue(r.GetOrdinal("male"))));
      Female = new SqlInt32(int.Parse(r.GetValue(r.GetOrdinal("female"))));
      Total = new SqlInt32(int.Parse(r.GetValue(r.GetOrdinal("total"))));
    }

  };
}
#region Source file version
// $Archive: /CLR.root/CLR/ETL/ufnParseHMDLifeSource.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: ufnParseHMDLifeSource.cs $
// $Modtime: 11/21/06 13:51 $
#endregion
        
using System;
using System.Collections;
using System.Data.SqlTypes;
using System.Globalization;
using System.IO;
using System.Security.Principal;
using Dreamdb.ETL.Text;
using Microsoft.SqlServer.Server;

namespace Dreamdb.ETL.Programmability
{
  public partial class UserDefinedFunctions
  {
    /// <summary>
    /// Table-valued function returning the result of parsing a set of files against the HMD Life-table format.
    /// </summary>
    /// <param name="searchpath">A top-level directory to search for input files.</param>
    /// <returns>A tabular resultset including header field values for use when catalogin filesets.</returns>
    [Microsoft.SqlServer.Server.SqlFunction(
      DataAccess = DataAccessKind.None,
      FillRowMethodName = "FillHMDLifeRecord",
      TableDefinition = "Setname nvarchar(30), Country nvarchar(20), Gender nvarchar(10), Modified datetime, Version nvarchar(20), Age tinyint, [Year] smallint, Rate float, Frequency float, AverageLived float, Survivors int, Deaths int, YearsLived int, YearsRemaining int, LifeExpectancy float"
      )]
    public static IEnumerable ufnParseHMDLifeSource(SqlString path, SqlString pattern)
    {

      string ptn = (pattern.IsNull) ? "*.txt" : pattern.Value;

      string[] filenames;
      using (WindowsIdentity wi = SqlContext.WindowsIdentity)
      {
        WindowsImpersonationContext wic = wi.Impersonate();
        filenames = Directory.GetFiles(path.Value, ptn, SearchOption.AllDirectories);
        wic.Undo();
      }

      HMDLifeRecordFormat f = new HMDLifeRecordFormat();
      TextRecordParser p = new TextRecordParser(f);
      p.SetInput(filenames);
      return p;
    }

    /// <summary>
    /// Callback function for the ufnParseHMDLifeTableFileset (called by SQL Server)
    /// </summary>
    /// <param name="record">A TextRecord containing a single record</param>
    /// <param name="Setname">The dataset name as used by HMD</param>
    /// <param name="Country">The country described in the file</param>
    /// <param name="Gender">Gender as string</param>
    /// <param name="Modified">Modification date</param>
    /// <param name="Version">HMD Version string</param>
    /// <param name="Age">Age</param>
    /// <param name="Year">Year of observation</param>
    /// <param name="Rate">Mortality rate</param>
    /// <param name="Frequency">Mortality frequency</param>
    /// <param name="AverageLived">Average number of years lived at time of death</param>
    /// <param name="Survivors">Number of survivors</param>
    /// <param name="Deaths">Number of deaths</param>
    /// <param name="YearsLived">Number of person-years lived</param>
    /// <param name="YearsRemaining">Number of person-years remaining</param>
    /// <param name="LifeExpectancy">Life-expectancy</param>
    public static void FillHMDLifeRecord(
      object record,
      out SqlString Setname,
      out SqlString Country,
      out SqlString Gender,
      out SqlDateTime Modified,
      out SqlString Version,
      out SqlByte Age,
      out SqlInt16 Year,
      out SqlDouble Rate,
      out SqlDouble Frequency,
      out SqlDouble AverageLived,
      out SqlInt32 Survivors,
      out SqlInt32 Deaths,
      out SqlInt32 YearsLived,
      out SqlInt32 YearsRemaining,
      out SqlDouble LifeExpectancy
    )
    {
      TextRecord r = (TextRecord)record;
      NumberFormatInfo nf = CultureInfo.GetCultureInfo(1033).NumberFormat;

      Country = new SqlString(r["country"].ToString());
      Setname = new SqlString(r["setname"].ToString());
      Modified = new SqlDateTime(DateTime.Parse(r["modified"].ToString()));
      Version = new SqlString(r["version"].ToString());
      Gender = new SqlString(r["gender"].ToString());
      Age = new SqlByte(byte.Parse(r["age"].ToString()));
      Year = new SqlInt16(Int16.Parse(r["year"].ToString()));
      Rate = new SqlDouble(float.Parse(r["rate"].ToString(), nf));
      Frequency = new SqlDouble(float.Parse(r["frequency"].ToString(), nf));
      AverageLived = new SqlDouble(float.Parse(r["averagelived"].ToString(), nf));
      Survivors = new SqlInt32(Int32.Parse(r["survivors"].ToString()));
      Deaths = new SqlInt32(Int32.Parse(r["deaths"].ToString()));
      YearsLived = new SqlInt32(Int32.Parse(r["yearslived"].ToString()));
      YearsRemaining = new SqlInt32(Int32.Parse(r["yearsremaining"].ToString()));
      LifeExpectancy = new SqlDouble(float.Parse(r["lifeexpectancy"].ToString(), nf));

    }

  };

}
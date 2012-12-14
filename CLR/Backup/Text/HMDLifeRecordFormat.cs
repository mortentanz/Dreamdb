#region Source file version
// $Archive: /CLR.root/CLR/Text/HMDLifeRecordFormat.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: HMDLifeRecordFormat.cs $
// $Modtime: 11/21/06 13:31 $
#endregion
        
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Dreamdb.ETL.Text
{
  public sealed class HMDLifeRecordFormat : TextRecordFormat
  {
    public HMDLifeRecordFormat() : base()
    {

      StringBuilder sb = new StringBuilder();
      sb.Append(@"(?<country>[a-zA-Z]*),\s*");
      sb.Append(@"(?<setname>[^,]*),\s*");
      sb.Append(@"(?<gender>[a-zA-Z]*)\s*Last modified: ");
      sb.Append(@"(?<modified>\d+-[A-Za-z]+-\d{4}),\s*");
      sb.Append(@"(?<version>.*)");
      m_headerrex = new Regex(sb.ToString(), RegexOptions.IgnoreCase);
      m_headerlocation = HeaderLocation.SourceText;

      sb = new StringBuilder(@"^\s*");
      sb.Append(@"(?<year>\d{4})\s*");
      sb.Append(@"(?<age>\d*)\+?\s*");
      sb.Append(@"(?<rate>\d+\.\d+)\s*");
      sb.Append(@"(?<frequency>\d+.\d*)\s*");
      sb.Append(@"(?<averagelived>\d+\.\d*)\s*");
      sb.Append(@"(?<survivors>\d*)\s*");
      sb.Append(@"(?<deaths>\d*)\s*");
      sb.Append(@"(?<yearslived>\d*)\s*");
      sb.Append(@"(?<yearsremaining>\d*)\s*");
      sb.Append(@"(?<lifeexpectancy>\d+\.\d*)$");
      m_recordrex = new Regex(sb.ToString(), RegexOptions.Multiline);

      m_fields.Add("country", true);
      m_fields.Add("setname", true);
      m_fields.Add("modified", true);
      m_fields.Add("version", true);
      m_fields.Add("gender", true);

      m_fields.Add("age");
      m_fields.Add("year");
      m_fields.Add("rate");
      m_fields.Add("frequency");
      m_fields.Add("averagelived");
      m_fields.Add("survivors");
      m_fields.Add("deaths");
      m_fields.Add("yearslived");
      m_fields.Add("yearsremaining");
      m_fields.Add("lifeexpectancy");

    }
  }
}

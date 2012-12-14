#region Source file version
// $Archive: /CLR.root/CLR/Text/TextRecordFormat.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: TextRecordFormat.cs $
// $Modtime: 9/11/06 14:25 $
#endregion
        
using System;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Globalization;

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// Defines the structure and format of text record data. A set of text records may well be characterized
  /// by metadata encoded in some type of header. The TextRecordFormat class supports such arrangements
  /// by prefixing each actual record with one or more header fields.
  /// </summary>
  public class TextRecordFormat
  {
    protected Regex m_recordrex;
    protected Regex m_headerrex;
    protected HeaderLocation m_headerlocation = HeaderLocation.None;
    protected TextRecordFieldCollection m_fields;

    /// <summary>
    /// Construct a simple default TextRecordFormat object. 
    /// </summary>
    public TextRecordFormat()
    {
      m_recordrex = new Regex("(?<RecordText>.*)");
      m_fields = new TextRecordFieldCollection();
    }

    /// <summary>
    /// Construct a TextRecordFormat object from a regular expression matching records.
    /// </summary>
    /// <param name="recordrex">A regular expression matching records. Each match group will be a field.</param>
    public TextRecordFormat(Regex recordrex)
    {
      m_recordrex = recordrex;
      m_fields = new TextRecordFieldCollection();
    }

    /// <summary>
    /// Construct a TextRecordFormat object from regular expressions matching records and filenames.
    /// </summary>
    /// <param name="recordrex">A regular expression matching records. Each match group will be a field.</param>
    /// <param name="headerrex">A regular expression matching header fields. Each match group will be a field.</param>
    /// <param name="headerlocation">A header location stating the location of header input text.</param>
    /// <exception cref="ArgumentException">Thrown if the header type is specified as HeaderLocation.None.</exception>
    public TextRecordFormat(Regex recordrex, Regex headerrex, HeaderLocation headerlocation)
    {
      if (headerlocation == HeaderLocation.None)
      {
        throw new ArgumentException("A header location type other than none must be specified if a header is defined.", "headertype");
      }
      m_recordrex = recordrex;
      m_headerrex = headerrex;
      m_headerlocation = headerlocation;
      m_fields = new TextRecordFieldCollection();
    }

    /// <summary>
    /// Gets the regular expression that will match individual records as passed in the constructor.
    /// </summary>
    public Regex RecordRegex
    {
      get { return m_recordrex; }
    }

    /// <summary>
    /// Gets the regular expression that will match header fields as passed in the constructor (may be null).
    /// </summary>
    public Regex HeaderRegex
    {
      get { return m_headerrex; }
    }

    /// <summary>
    /// Gets a value indicating if the format incorporates header fields.
    /// </summary>
    public bool HasHeader
    {
      get { return (m_headerrex != null && m_headerlocation != HeaderLocation.None); }
    }

    /// <summary>
    /// Gets the CultureInfo used for converting text to numeric values.
    /// </summary>
    public virtual CultureInfo CultureInfo
    {
      get { return CultureInfo.CurrentCulture; }
    }

    /// <summary>
    /// Get the location of the header data as passed in the constructor.
    /// </summary>
    public HeaderLocation HeaderLocation
    {
      get { return m_headerlocation; }
    }

    /// <summary>
    /// A TextRecordFieldCollection of meta data for the fields defined by this record format.
    /// </summary>
    public TextRecordFieldCollection Fields
    {
      get 
      {
        if (m_fields.Count == 0)
        {
          m_fields = new TextRecordFieldCollection(this);
        }
        return m_fields; 
      }
    }

    /// <summary>
    /// Gets an array of field names (header fields, record fields and any additional fields).
    /// </summary>
    /// <returns>A string array containing the names of the fields defined by the format.</returns>
    public string[] GetFieldNames()
    {
      List<string> names = new List<string>(Fields.Count);
      foreach (TextRecordField f in Fields)
      {
        names.Add(f.Name);
      }
      return names.ToArray();
    }

    /// <summary>
    /// Gets an array of header field names.
    /// </summary>
    /// <returns>A string array containing the names of the header fields (may be null).</returns>
    public virtual string[] GetHeaderFieldNames()
    {
      if (HasHeader)
      {
        string[] gns = m_headerrex.GetGroupNames();
        string[] ns = new string[gns.Length - 1];
        for (int i = 1; i < gns.Length; i++)
        {
          ns[i - 1] = gns[i];
        }
        return ns;
      }
      else
      {
        return null;
      }
    }

    /// <summary>
    /// Gets an array of record field names (fields with record data).
    /// </summary>
    /// <returns>A string array containing the names of the record fields.</returns>
    public virtual string[] GetRecordFieldNames()
    {
      string[] gns = m_recordrex.GetGroupNames();
      string[] ns = new string[gns.Length - 1];
      for (int i = 1; i < gns.Length; i++)
      {
        ns[i - 1] = gns[i];
      }
      return ns;
    }

    /// <summary>
    /// Creates TextRecordReader compatible with the record structure defined by this format.
    /// </summary>
    /// <param name="parser">A TextRecordParser with which the TextRecordReader is to be associated.</param>
    /// <returns>A TextRecordReader enabling type conversions etc. for this specific format.</returns>
    public virtual TextRecordReader CreateReader(TextRecordParser parser)
    {
      return new TextRecordReader(parser);
    }

  }
}
